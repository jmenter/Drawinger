
#import <UIKit/UIKit.h>

@interface UIDrawingView : UIView

@property (nonatomic) UIColor *drawingColor;
@property CGLineCap lineCapStyle;
@property CGLineJoin lineJoinStyle;
@property CGFloat lineWidth;

- (void)reset;

@end
