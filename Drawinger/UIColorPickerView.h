
#import <UIKit/UIKit.h>

@class UIColorPickerView;

@protocol UIColorPickerViewDelegate
- (void)colorPickerView:(nonnull UIColorPickerView *)colorPickerView
           didPickColor:(nonnull UIColor *)color;
@end


@interface UIColorPickerView : UIView

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, readonly, nonnull) UIColor *currentColor;
@property (nonatomic, weak, nullable) IBOutlet id<UIColorPickerViewDelegate> colorPickerDelegate;

@end
