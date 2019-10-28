
#import "NSArray+Extras.h"

@implementation NSArray (Extras)

- (void)forEach:(void (^)(id obj))block;
{
    if (!block) return;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { block(obj); }];
}

@end
