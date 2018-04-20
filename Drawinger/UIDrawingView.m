
#import "UIDrawingView.h"
#import "UIBezierPath+Extras.h"
#import "UITouch+Extras.h"

@interface UIDrawingView()
@property (nonatomic) NSMutableDictionary <NSString *, UIBezierPath *> *touchPaths;
@property (nonatomic) NSMutableArray <UIBezierPath *> *drawingPaths;
@end

@implementation UIDrawingView

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.contentMode = UIViewContentModeRedraw;
    
    [self reset];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        UIBezierPath *path = [self createPathAtPoint:touch.location];
        [self addTouch:touch toPath:path];
        self.touchPaths[touch.identifier] = path;
        [self.drawingPaths addObject:path];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self addTouch:touch toPath:self.touchPaths[touch.identifier]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
    for (UITouch *touch in touches) {
        self.touchPaths[touch.identifier] = nil;
    }
}

- (UIBezierPath *)createPathAtPoint:(CGPoint)point;
{
    UIBezierPath *path = UIBezierPath.new;
    path.strokeColor = self.drawingColor;
    path.lineCapStyle = self.lineCapStyle;
    path.lineJoinStyle = self.lineJoinStyle;
    path.lineWidth = self.lineWidth;
    [path moveToPoint:point];
    
    return path;
}

- (void)addTouch:(UITouch *)touch toPath:(UIBezierPath *)path;
{
    [path addQuadCurveToPoint:CGPointMake((touch.previousLocation.x + touch.location.x) / 2.f, (touch.previousLocation.y + touch.location.y) / 2.f) controlPoint:touch.previousLocation];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.drawingPaths) {
        [path.strokeColor setStroke];
        [path stroke];
    }
}

- (void)reset;
{
    self.touchPaths = NSMutableDictionary.new;
    self.drawingPaths = NSMutableArray.new;
    self.drawingColor = UIColor.blackColor;
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle = kCGLineJoinRound;
    self.lineWidth = 2.f;
    [self setNeedsDisplay];
}


@end
