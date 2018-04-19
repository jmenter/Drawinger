
#import <UIKit/UIKit.h>
#import "UIColorPickerView.h"

@interface UIDrawingView : UIView <UIColorPickerViewDelegate>

@property (nonatomic) UIColor *drawingColor;
@property CGLineCap lineCapStyle;
@property CGLineJoin lineJoinStyle;
@property CGFloat lineWidth;

- (IBAction)setLineCapStyleAction:(UISegmentedControl *)sender;
- (IBAction)setLineJoinStyleAction:(UISegmentedControl *)sender;
- (IBAction)setLineWidthAction:(UISlider *)sender;
- (IBAction)reset;

@end
