
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

@end
