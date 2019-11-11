
@import UIKit;

@class UIStyle;
@class UIStylePickerView;

@protocol UIStylePickerDelegate
- (void)stylePickerViewDidPickAStyle:(UIStylePickerView *)stylePickerView;
- (void)stylePickerView:(UIStylePickerView *)stylePickerView
         didRequestMove:(CGPoint)amount;
@end

@interface UIStylePickerView : UIView

@property (nonatomic, readonly) UIStyle *currentStyle;
@property (nonatomic, weak) IBOutlet id<UIStylePickerDelegate> stylePickerDelegate;

@end
