
@import UIKit;

@interface UIStyle : NSObject

@property (nonatomic) UIColor * _Nonnull color;
@property (nonatomic) CGFloat lineWidth;

+ (instancetype _Nonnull )styleWithColor:(UIColor *_Nonnull)color lineWidth:(CGFloat)lineWidth;

@end


