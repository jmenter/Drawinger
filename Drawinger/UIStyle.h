
@import UIKit;

@interface UIStyle : NSObject

@property (nonatomic) UIColor * _Nonnull color;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGLineCap lineCap;
@property (nonatomic) CGLineJoin lineJoin;

- (instancetype _Nullable )init;

+ (instancetype _Nonnull )styleWithColor:(UIColor *_Nonnull)color lineWidth:(CGFloat)lineWidth;
+ (instancetype _Nonnull )styleWithColor:(UIColor *_Nonnull)color lineWidth:(CGFloat)lineWidth lineCap:(CGLineCap)lineCap lineJoin:(CGLineJoin)lineJoin;

@end


