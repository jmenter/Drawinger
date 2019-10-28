
#import "UITouch+Extras.h"
#import "CGExtras.h"

@implementation UITouch (Extras)

- (nonnull NSString *)identifier;
{
    return [NSString stringWithFormat:@"%p", self];
}

- (CGPoint)location;
{
    return [self locationInView:self.view];
}

- (CGPoint)previousLocation;
{
    return [self previousLocationInView:self.view];
}

- (CGPoint)halfPreviousLocation;
{
    return CGPointDivide(CGPointAddPoints(self.previousLocation, self.location), 2.f);
}

@end
