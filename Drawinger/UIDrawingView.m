
#import "UIDrawingView.h"
#import "UIBezierPath+Extras.h"
#import "UITouch+Extras.h"

@interface UIDrawingView()
@property (nonatomic) NSMutableDictionary <NSString *, UIBezierPath *> *touchPaths;
@property (nonatomic) NSMutableArray <UIBezierPath *> *drawingPaths;
@property (nonatomic) UIImage *drawingStore;
@property (nonatomic) UIImageView *drawingStoreView;
@property (nonatomic) CGFloat max;
@end

@implementation UIDrawingView

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = UIColor.clearColor;
    self.max = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.drawingStoreView = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, self.max, self.max)];
    self.drawingStoreView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.drawingStoreView.backgroundColor = UIColor.clearColor;
    self.drawingStoreView.contentMode = UIViewContentModeTopLeft;
    [self reset];
    return self;
}

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    [self.superview insertSubview:self.drawingStoreView belowSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        UIBezierPath *path = [self createPathAtPoint:touch.location];
        [self addTouch:touch toPath:path];
        self.touchPaths[touch.identifier] = path;
        [self.drawingPaths addObject:path];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self addTouch:touch toPath:self.touchPaths[touch.identifier]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self addTouch:touch toPath:self.touchPaths[touch.identifier]];
        self.touchPaths[touch.identifier] = nil;
    }
    if (self.touchPaths.count == 0) {
        [self commitPaths];
    }
}

- (void)commitPaths;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.max, self.max), NO, 0);
    if (self.drawingStore) {
        [self.drawingStore drawAtPoint:CGPointZero];
    }
    [self drawRect:self.bounds];
    self.drawingStore = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.drawingStoreView.image = self.drawingStore;
    self.drawingPaths = NSMutableArray.new;
}

- (UIBezierPath *)createPathAtPoint:(CGPoint)point;
{
    UIBezierPath *path = UIBezierPath.new;
    path.strokeColor = self.drawingColor;
    path.lineCapStyle = self.lineCapStyle;
    path.lineJoinStyle = self.lineJoinStyle;
    path.lineWidth = self.lineWidth;
    [path moveToPoint:point];
    
    return path;
}

- (void)addTouch:(UITouch *)touch toPath:(UIBezierPath *)path;
{
    [path addQuadCurveToPoint:touch.halfPreviousLocation controlPoint:touch.previousLocation];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.drawingPaths) {
        [path.strokeColor setStroke];
        [path stroke];
    }
}

- (void)reset;
{
    self.touchPaths = NSMutableDictionary.new;
    self.drawingPaths = NSMutableArray.new;
    self.drawingColor = UIColor.blackColor;
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle = kCGLineJoinRound;
    self.lineWidth = 2.f;
    self.drawingStore = nil;
    self.drawingStoreView.image = nil;
    [self setNeedsDisplay];
}


@end
