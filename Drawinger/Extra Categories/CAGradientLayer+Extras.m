
#import "CAGradientLayer+Extras.h"

@implementation CAGradientLayer (Extras)

+ (instancetype)maskedLayer;
{
    CAGradientLayer *layer = [self class].layer;
    layer.masksToBounds = YES;
    return layer;
}

@end
