
#import "UIBezierPath+Extras.h"
#import <objc/runtime.h>

@implementation UIBezierPath (Extras)

@dynamic strokeColor;

- (void)setStrokeColor:(UIColor *)color;
{
    objc_setAssociatedObject(self, @selector(strokeColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)strokeColor;
{
    return objc_getAssociatedObject(self, @selector(strokeColor));
}

@end
