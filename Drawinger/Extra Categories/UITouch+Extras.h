
@import UIKit;

@interface UITouch (Extras)

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) CGPoint location;
@property (nonatomic, readonly) CGPoint previousLocation;
@property (nonatomic, readonly) CGPoint halfPreviousLocation;

@end
