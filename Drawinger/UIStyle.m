
#import "UIStyle.h"

@implementation UIStyle : NSObject

- (instancetype)init;
{
    if (!(self = [super init])) { return nil; }
    
    self.color = UIColor.blackColor;
    self.lineWidth = 5;
    self.lineCap = kCGLineCapRound;
    self.lineJoin = kCGLineJoinRound;
    return self;
}


+ (instancetype)styleWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;
{
    UIStyle *style = UIStyle.new;
    style.color = color;
    style.lineWidth = lineWidth;
    return style;
}

+ (instancetype)styleWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth lineCap:(CGLineCap)lineCap lineJoin:(CGLineJoin)lineJoin;
{
    UIStyle *style = [self styleWithColor:color lineWidth:lineWidth];
    style.lineCap = lineCap;
    style.lineJoin = lineJoin;
    return style;
}

@end
