
#import <UIKit/UIKit.h>

@class UIColorPickerView;

@protocol UIColorPickerViewDelegate
- (void)colorPickerView:(UIColorPickerView *)colorPickerView didPickColor:(UIColor *)color;
@end


@interface UIColorPickerView : UIView

@property (nonatomic, readonly) UIColor *currentColor;
@property (nonatomic, weak) IBOutlet id<UIColorPickerViewDelegate> colorPickerDelegate;

@end
