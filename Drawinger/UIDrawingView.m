
#import "UIDrawingView.h"
#import "UIBezierPath+Extras.h"
#import "UITouch+Extras.h"

@interface UIDrawingView()
@property (nonatomic) NSMutableDictionary <NSString *, UIBezierPath *> *touchPaths;
@property (nonatomic) NSMutableArray <UIBezierPath *> *drawingPaths;
@property (nonatomic) UIImage *drawingStoreImage;
@property (nonatomic) UIImageView *drawingStoreImageView;
@property (nonatomic) CGFloat maxDimension;
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
    self.maxDimension = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.drawingStoreImageView = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, self.maxDimension, self.maxDimension)];
    self.drawingStoreImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.drawingStoreImageView.backgroundColor = UIColor.clearColor;
    self.drawingStoreImageView.contentMode = UIViewContentModeTopLeft;
    [self reset];
    return self;
}

- (void)reset;
{
    self.touchPaths = NSMutableDictionary.new;
    self.drawingPaths = NSMutableArray.new;
    self.drawingColor = UIColor.blackColor;
    self.lineCapStyle = kCGLineCapRound;
    self.lineJoinStyle = kCGLineJoinRound;
    self.lineWidth = 2.f;
    self.drawingStoreImage = nil;
    self.drawingStoreImageView.image = nil;
    [self setNeedsDisplay];
}

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    [self.superview insertSubview:self.drawingStoreImageView belowSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    for (UITouch *touch in touches) {
        UIBezierPath *path = [UIBezierPath pathAtPoint:touch.location strokeColor:self.drawingColor
                                          lineCapStyle:self.lineCapStyle lineJoinStyle:self.lineJoinStyle
                                             lineWidth:self.lineWidth];
        [self addTouch:touch toPath:path];
        self.touchPaths[touch.identifier] = path;
        [self.drawingPaths addObject:path];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    for (UITouch *touch in touches) {
        [self addTouch:touch toPath:self.touchPaths[touch.identifier]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchesMoved:touches withEvent:event];
    for (UITouch *touch in touches) {
        self.touchPaths[touch.identifier] = nil;
    }
    if (self.touchPaths.count == 0) {
        [self commitDrawingPaths];
    }
}

- (void)addTouch:(UITouch *)touch toPath:(UIBezierPath *)path;
{
    [path addQuadCurveToPoint:touch.halfPreviousLocation controlPoint:touch.previousLocation];
    [self setNeedsDisplay];
}

- (void)commitDrawingPaths;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.maxDimension, self.maxDimension), NO, 0);
    [self.drawingStoreImage drawAtPoint:CGPointZero];
    [self drawRect:self.bounds];
    self.drawingStoreImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.drawingStoreImageView.image = self.drawingStoreImage;
    [self.drawingPaths removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.drawingPaths) {
        [path.strokeColor setStroke];
        [path stroke];
    }
}

@end
