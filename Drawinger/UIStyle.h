
@import UIKit;

@interface UIStyle : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGLineCap lineCap;
@property (nonatomic) CGLineJoin lineJoin;

- (instancetype)init;

+ (instancetype)styleWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;
+ (instancetype)styleWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth lineCap:(CGLineCap)lineCap lineJoin:(CGLineJoin)lineJoin;

@end


