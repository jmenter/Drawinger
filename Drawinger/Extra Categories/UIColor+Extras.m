
#import "UIColor+Extras.h"
#import "UIImage+Extras.h"

@implementation UIColor (Extras)

+ (instancetype)transparencyPattern;
{
    return [self.class colorWithPatternImage:UIImage.checkerboard];
}

@end
