
#import "UIGestureRecognizer+Extras.h"

@implementation UIGestureRecognizer (Extras)

- (CGPoint)location;
{
    return [self locationInView:self.view];
}

@end
