
#import "UIColor+Extras.h"
#import "UIImage+Extras.h"

@implementation UIColor (Extras)

+ (UIColor *)transparencyPattern;
{
    return [UIColor colorWithPatternImage:UIImage.checkerboard];
}

@end
