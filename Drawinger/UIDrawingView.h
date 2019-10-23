
@import UIKit;
#import "UIStyle.h"

@interface UIDrawingView : UIView

@property (nonatomic, nonnull) UIColor *drawingColor;
@property CGLineCap lineCapStyle;
@property CGLineJoin lineJoinStyle;
@property CGFloat lineWidth;

- (void)reset;
- (void)applyStyle:(UIStyle *_Nonnull)style;

@end
