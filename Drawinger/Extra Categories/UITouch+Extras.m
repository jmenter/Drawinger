
#import "UITouch+Extras.h"

@implementation UITouch (Extras)
@dynamic identifier;
@dynamic location;
@dynamic previousLocation;

- (NSString *)identifier;
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
    return CGPointMake((self.previousLocation.x + self.location.x) / 2.f,
                       (self.previousLocation.y + self.location.y) / 2.f);;
}

@end
