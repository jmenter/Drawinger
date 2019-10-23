
#import "UIStyle.h"

@implementation UIStyle : NSObject

+ (instancetype _Nonnull )styleWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;
{
    UIStyle *style = UIStyle.new;
    style.color = color;
    style.lineWidth = lineWidth;
    return style;
}

@end
