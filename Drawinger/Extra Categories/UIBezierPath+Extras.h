
@import UIKit;
#import "UIStyle.h"

@interface UIBezierPath (Extras)

@property (nonatomic) UIColor *strokeColor;

+ (UIBezierPath *)pathAtPoint:(CGPoint)point style:(UIStyle *)style;

- (void)strokeWithCurrentStrokeColor;

- (void)addTouch:(UITouch *)touch;

@end
