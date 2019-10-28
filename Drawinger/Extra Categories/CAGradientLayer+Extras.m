
#import "CAGradientLayer+Extras.h"
#import "UIColor+Extras.h"

@implementation CAGradientLayer (Extras)

+ (instancetype)maskedLayer;
{
    CAGradientLayer *layer = [self class].layer;
    layer.masksToBounds = YES;
    return layer;
}

+ (instancetype)alphaLayer;
{
    CAGradientLayer *layer = CAGradientLayer.maskedLayer;
    layer.backgroundColor = UIColor.transparencyPattern.CGColor;
    return layer;
}

+ (instancetype)saturationLayer;
{
    CAGradientLayer *layer = CAGradientLayer.maskedLayer;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    return layer;
}

+ (instancetype)brightnessLayer;
{
    CAGradientLayer *layer = CAGradientLayer.maskedLayer;
    layer.colors = @[(id)[UIColor colorWithHue:0 saturation:0 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1].CGColor];
    return layer;
}

+ (instancetype)hueLayer;
{
    CAGradientLayer *layer = CAGradientLayer.maskedLayer;
    layer.colors = @[(id)[UIColor colorWithHue:0.0 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.2 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.4 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.6 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.8 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:1.0 saturation:1 brightness:1 alpha:1].CGColor];
    return layer;
}

@end
