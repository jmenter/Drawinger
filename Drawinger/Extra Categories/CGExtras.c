
#include "CGExtras.h"

CGPoint CGPointAddPoints(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint CGPointSubtractPoints(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

CGPoint CGPointDivide(CGPoint point, CGFloat amount) {
    return CGPointMake(point.x / amount, point.y / amount);
}

CGPoint CGPointQuantize(CGPoint point) {
    return CGPointMake((long)point.x, (long)point.y);
}
