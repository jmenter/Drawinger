
#import "UIDrawingView.h"
#import <objc/runtime.h>

@interface UIBezierPath (AssociatedObject)
@property (nonatomic, strong) UIColor *strokeColor;
@end

@implementation UIBezierPath (AssociatedObject)
@dynamic strokeColor;

- (void)setStrokeColor:(UIColor *)color {
    objc_setAssociatedObject(self, @selector(strokeColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)strokeColor {
    return objc_getAssociatedObject(self, @selector(strokeColor));
}
@end

@implementation NSObject(Extras)
- (NSString *)identifier; { return [NSString stringWithFormat:@"%p", self]; }
@end

@interface UIDrawingView()
@property (nonatomic) NSMutableDictionary <NSString *, UIBezierPath *> *touchPaths;
@property (nonatomic) NSMutableArray <UIBezierPath *> *drawingPaths;
@property (nonatomic) NSMutableDictionary <NSString *, NSValue *> *previousPoints;
@end

@implementation UIDrawingView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.touchPaths = NSMutableDictionary.new;
    self.drawingPaths = NSMutableArray.new;
    self.previousPoints = NSMutableDictionary.new;
    
    self.drawingColor = UIColor.blackColor;
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle = kCGLineJoinRound;
    self.lineWidth = 2.f;
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        UIBezierPath *path = UIBezierPath.new;
        path.strokeColor = self.drawingColor;
        path.lineCapStyle =self.lineCapStyle;
        path.lineJoinStyle = self.lineJoinStyle;
        path.lineWidth = self.lineWidth;
        
        CGPoint point = [touch locationInView:self];
        [path moveToPoint:point];
        
        [self addPoint:point toPath:path previousPoint:point];

        self.touchPaths[touch.identifier] = path;
        [self.drawingPaths addObject:path];
        self.previousPoints[touch.identifier] = [NSValue valueWithCGPoint:point];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        UIBezierPath *path = self.touchPaths[touch.identifier];
        CGPoint point = [touch locationInView:self];
        CGPoint previousPoint = self.previousPoints[touch.identifier].CGPointValue;
        [self addPoint:point toPath:path previousPoint:previousPoint];
        self.previousPoints[touch.identifier] = [NSValue valueWithCGPoint:point];

    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
    for (UITouch *touch in touches) {
        self.touchPaths[touch.identifier] = nil;
        self.previousPoints[touch.identifier] = nil;
    }
}

- (void)addPoint:(CGPoint)point toPath:(UIBezierPath *)path previousPoint:(CGPoint)previousPoint {
    [path addQuadCurveToPoint:CGPointMake((previousPoint.x + point.x) / 2.f, (previousPoint.y + point.y) / 2.f) controlPoint:previousPoint];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.drawingPaths) {
        [path.strokeColor setStroke];
        [path stroke];
    }
}

- (void)setLineCapStyleAction:(UISegmentedControl *)sender;
{
    self.lineCapStyle = (CGLineCap)sender.selectedSegmentIndex;
}

- (void)setLineJoinStyleAction:(UISegmentedControl *)sender;
{
    self.lineJoinStyle = (CGLineJoin)sender.selectedSegmentIndex;
}

- (void)setLineWidthAction:(UISlider *)sender;
{
    self.lineWidth = sender.value;
}

- (void)reset;
{
    self.drawingPaths = NSMutableArray.new;
    [self setNeedsDisplay];
}

- (void)colorPickerView:(UIColorPickerView *)colorPickerView didPickColor:(UIColor *)color;
{
    self.drawingColor = color;
}

@end
