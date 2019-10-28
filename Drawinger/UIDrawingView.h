
@import UIKit;
#import "UIStyle.h"

@interface UIDrawingView : UIView

@property (nonatomic) UIStyle *currentDrawingStyle;

- (void)reset;
- (void)resetWithDrawingStyle:(UIStyle *)style;

@end
