
#import <UIKit/UIKit.h>

@interface UIBezierPath (Extras)

@property (nonatomic, strong) UIColor *strokeColor;

+ (UIBezierPath *)pathAtPoint:(CGPoint)point
                  strokeColor:(UIColor *)strokeColor
                 lineCapStyle:(CGLineCap)lineCapStyle
                lineJoinStyle:(CGLineJoin)lineJoinStyle
                    lineWidth:(CGFloat)lineWidth;

- (void)strokeWithCurrentStrokeColor;

- (void)addTouchToPath:(UITouch *)touch;

@end
