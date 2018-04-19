
#import "UIImage+Extras.h"

@implementation UIImage (Extras)

+ (UIImage *)checkerboard;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(8, 8), YES, 0);
    [UIColor.whiteColor setFill];
    UIRectFill(CGRectMake(0, 0, 8, 8));
    [[UIColor colorWithWhite:0.75 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, 4, 4));
    UIRectFill(CGRectMake(4, 4, 4, 4));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
