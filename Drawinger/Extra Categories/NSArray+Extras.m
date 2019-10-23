
#import "NSArray+Extras.h"

@implementation NSArray (Extras)

- (void)forEach:(void (^)(id obj))block;
{
    if (!block) return;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { block(obj); }];
}

@end
