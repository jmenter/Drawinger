
@import UIKit;

@class UIStyle;

@interface UIBezierPath (Extras)

@property (nonatomic) UIColor *strokeColor;

+ (UIBezierPath *)newPathAtPoint:(CGPoint)point style:(UIStyle *)style;

- (void)strokeWithCurrentStrokeColor;
- (void)addCurveFromTouch:(UITouch *)touch;

@end
