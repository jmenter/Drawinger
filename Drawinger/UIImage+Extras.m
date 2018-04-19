
#import "UIImage+Extras.h"

@implementation UIImage (Extras)

+ (UIImage *)checkerboard;
{
    return [self checkerboardWithGridSize:CGSizeMake(4, 4)];
}

+ (UIImage *)checkerboardWithGridSize:(CGSize)gridSize;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(gridSize.width * 2, gridSize.height * 2), YES, 0);
    [UIColor.whiteColor setFill];
    UIRectFill(CGRectMake(0, 0, gridSize.width * 2, gridSize.height * 2));
    [[UIColor colorWithWhite:0.75 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, gridSize.width, gridSize.height));
    UIRectFill(CGRectMake(gridSize.width, gridSize.height, gridSize.width, gridSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

@end
