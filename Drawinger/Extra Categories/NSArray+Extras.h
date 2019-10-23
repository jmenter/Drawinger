
@import Foundation;

@interface NSArray <__covariant ObjectType> (Extras)

- (void)forEach:(void (^)(ObjectType obj))block;

@end
