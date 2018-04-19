
#import "UIDrawingView.h"
#import "UIBezierPath+Extras.h"
#import "UITouch+Extras.h"

@interface UIDrawingView()
@property (nonatomic) NSMutableDictionary <NSString *, UIBezierPath *> *touchPaths;
@property (nonatomic) NSMutableArray <UIBezierPath *> *drawingPaths;
@end

@implementation UIDrawingView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reset];
    
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
        path.lineCapStyle = self.lineCapStyle;
        path.lineJoinStyle = self.lineJoinStyle;
        path.lineWidth = self.lineWidth;
        
        [path moveToPoint:touch.location];
        [self addPoint:touch.location toPath:path previousPoint:touch.location];

        self.touchPaths[touch.identifier] = path;
        [self.drawingPaths addObject:path];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self addPoint:touch.location toPath:self.touchPaths[touch.identifier] previousPoint:touch.previousLocation];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
    for (UITouch *touch in touches) {
        self.touchPaths[touch.identifier] = nil;
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
    self.touchPaths = NSMutableDictionary.new;
    self.drawingPaths = NSMutableArray.new;
    [self setNeedsDisplay];
}

- (void)colorPickerView:(UIColorPickerView *)colorPickerView didPickColor:(UIColor *)color;
{
    self.drawingColor = color;
}

@end
