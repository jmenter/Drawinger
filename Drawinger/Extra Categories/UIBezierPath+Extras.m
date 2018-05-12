
#import "UIBezierPath+Extras.h"
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

+ (UIBezierPath *)pathAtPoint:(CGPoint)point
                  strokeColor:(UIColor *)strokeColor
                 lineCapStyle:(CGLineCap)lineCapStyle
                lineJoinStyle:(CGLineJoin)lineJoinStyle
                    lineWidth:(CGFloat)lineWidth;
{
    UIBezierPath *path = UIBezierPath.new;
    path.strokeColor = strokeColor;
    path.lineCapStyle = lineCapStyle;
    path.lineJoinStyle = lineJoinStyle;
    path.lineWidth = lineWidth;
    [path moveToPoint:point];
    
    return path;
}

@end
