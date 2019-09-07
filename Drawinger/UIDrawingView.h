
@import UIKit;

@interface UIDrawingView : UIView

@property (nonatomic, nonnull) UIColor *drawingColor;
@property CGLineCap lineCapStyle;
@property CGLineJoin lineJoinStyle;
@property CGFloat lineWidth;

- (void)reset;

@end
