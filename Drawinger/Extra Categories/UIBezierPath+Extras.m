
#import "UIBezierPath+Extras.h"
#import "UITouch+Extras.h"

#import <objc/runtime.h>

@implementation UIBezierPath (Extras)

@dynamic strokeColor;

- (void)setStrokeColor:(UIColor *)color;
{
    objc_setAssociatedObject(self, @selector(strokeColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)strokeColor;
{
    return objc_getAssociatedObject(self, @selector(strokeColor));
}

+ (UIBezierPath *)pathAtPoint:(CGPoint)point style:(UIStyle *)style;
{
    UIBezierPath *path = UIBezierPath.new;
    path.lineWidth = style.lineWidth;
    path.strokeColor = style.color;
    path.lineCapStyle = style.lineCap;
    path.lineJoinStyle = style.lineJoin;
    [path moveToPoint:point];
    
    return path;
}

- (void)strokeWithCurrentStrokeColor;
{
    [self.strokeColor setStroke];
    [self stroke];
}

- (void)addTouch:(UITouch *)touch;
{
    [self addQuadCurveToPoint:touch.halfPreviousLocation controlPoint:touch.previousLocation];
}

@end
