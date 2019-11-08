
@import UIKit;
#import "UIStyle.h"

@class UIStylePickerView;

@protocol UIStylePickerViewDelegate
- (void)stylePickerViewDidPickAStyle:(UIStylePickerView *)stylePickerView;
- (void)stylePickerView:(UIStylePickerView *)stylePickerView
         didRequestMove:(CGPoint)amount;
@end

@interface UIStylePickerView : UIView

@property (nonatomic, readonly) UIStyle *currentStyle;
@property (nonatomic, weak) IBOutlet id<UIStylePickerViewDelegate> stylePickerDelegate;

@end
