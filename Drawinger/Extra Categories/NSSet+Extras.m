
#import "NSSet+Extras.h"

@implementation NSSet (Extras)

- (void)forEach:(void (^)(id obj))block;
{
    if (!block) return;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) { block(obj); }];
}

@end
