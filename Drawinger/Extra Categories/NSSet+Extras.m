
#import "NSSet+Extras.h"

@implementation NSSet (Extras)

- (void)forEach:(void (^)(id obj))block;
{
    if (!block) return;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) { block(obj); }];
}

@end
