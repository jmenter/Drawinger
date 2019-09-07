
#import <UIKit/UIKit.h>

@interface UITouch (Extras)

@property (nonatomic, readonly, nonnull) NSString *identifier;
@property (nonatomic, readonly) CGPoint location;
@property (nonatomic, readonly) CGPoint previousLocation;
@property (nonatomic, readonly) CGPoint halfPreviousLocation;

@end
