
#ifndef CGExtras_h
#define CGExtras_h

#include <CoreGraphics/CoreGraphics.h>

CGPoint CGPointAddPoints(CGPoint point1, CGPoint point2);
CGPoint CGPointSubtractPoints(CGPoint point1, CGPoint point2);
CGPoint CGPointDivide(CGPoint point, CGFloat amount);
CGPoint CGPointQuantize(CGPoint point);

#endif /* CGExtras_h */
