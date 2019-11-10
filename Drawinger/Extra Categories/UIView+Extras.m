
#import "UIView+Extras.h"

@implementation UIView (Extras)

static const NSTimeInterval kStandardFadeDuration = 0.2;

- (void)fadeIn;
{
    [self fadeIn:kStandardFadeDuration];
}

- (void)fadeIn:(NSTimeInterval)duration;
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

- (void)fadeOut;
{
    [self fadeOut:kStandardFadeDuration];
}

- (void)fadeOut:(NSTimeInterval)duration;
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }];
}

@end
