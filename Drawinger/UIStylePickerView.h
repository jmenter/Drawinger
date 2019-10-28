
@import UIKit;
#import "UIStyle.h"

@class UIStylePickerView;

@protocol UIStylePickerViewDelegate
- (void)stylePickerViewDidPickStyle:(nonnull UIStylePickerView *)stylePickerView;
- (void)stylePickerView:(nonnull UIStylePickerView *)stylePickerView
         didRequestMove:(CGPoint)amount;
@end


@interface UIStylePickerView : UIView

@property (nonatomic, readonly, nonnull) UIStyle *currentStyle;
@property (nonatomic, weak, nullable) IBOutlet id<UIStylePickerViewDelegate> stylePickerDelegate;

@end
