
@import UIKit;

@class UIStyle;

@interface UIDrawingView : UIView

@property (nonatomic) UIStyle *currentDrawingStyle;

- (void)reset;
- (void)resetWithDrawingStyle:(UIStyle *)style;

@end
