
#import "UIStylePickerView.h"
#import "UIColor+Extras.h"
#import "UIImage+Extras.h"
#import "UITouch+Extras.h"
#import "NSSet+Extras.h"
#import "CGExtras.h"

typedef NS_ENUM(NSUInteger, TouchArea) {
    TouchAreaHue,
    TouchAreaSaturationBrightness,
    TouchAreaAlpha,
};

@interface UIStylePickerView()
@property (nonatomic) CGFloat currentHue;
@property (nonatomic) CGFloat currentSaturation;
@property (nonatomic) CGFloat currentBrightness;
@property (nonatomic) CGFloat currentAlpha;

@property (nonatomic) CAGradientLayer *hueLayer;
@property (nonatomic) CAGradientLayer *saturationLayer;
@property (nonatomic) CAGradientLayer *brightnessLayer;
@property (nonatomic) CAGradientLayer *alphaLayer;

@property (nonatomic) UIView *hueIndicator;
@property (nonatomic) UIView *saturationBrightnessIndicator;
@property (nonatomic) UIView *alphaIndicator;

@property (nonatomic) UILabel *valuesLabel;
@property (nonatomic) TouchArea touchArea;
@property (nonatomic, readwrite, nonnull) UIStyle *currentStyle;

@end

@implementation UIStylePickerView

static const CGFloat kHueBarWidth = 30;
static const CGFloat kValueLabelTouchOffset = 50;

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = YES;
    self.currentHue = 0;
    self.currentSaturation = 0.5;
    self.currentBrightness = 0.75;
    self.currentAlpha = 1;

    self.currentStyle = [UIStyle styleWithColor:[UIColor colorWithHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:self.currentAlpha] lineWidth:5];
    self.saturationLayer = [self createSaturationLayer];
    self.brightnessLayer = [self createBrightnessLayer];
    self.hueLayer = [self createHueLayer];
    self.alphaLayer = [self createAlphaLayer];

    self.hueIndicator = [self createIndicatorView];
    self.alphaIndicator = [self createIndicatorView];
    self.saturationBrightnessIndicator = [self createSaturationBrightnessIndicator];
    self.valuesLabel = [self createValuesLabel];

    [self addSubview:self.hueIndicator];
    [self addSubview:self.alphaIndicator];
    [self addSubview:self.saturationBrightnessIndicator];
    [self addSubview:self.valuesLabel];
    
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeZero;
    self.contentMode = UIViewContentModeRedraw;

    UIPinchGestureRecognizer *pinchGr = [UIPinchGestureRecognizer.alloc initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGr];

    UIPanGestureRecognizer *panGr = [UIPanGestureRecognizer.alloc initWithTarget:self action:@selector(handlePan:)];
    panGr.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:panGr];

    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)panGR;
{
    static CGPoint previousLocation;
    if (panGR.state == UIGestureRecognizerStateBegan) {
        previousLocation = [panGR locationInView:self];
    } else if (panGR.state == UIGestureRecognizerStateChanged) {
        CGPoint currentLocation = [panGR locationInView:self];
        [self.stylePickerDelegate stylePickerView:self didRequestMove:CGPointSubtractPoints(currentLocation, previousLocation)];
        previousLocation = currentLocation;
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGR;
{
    self.currentStyle.lineWidth *= pinchGR.scale;
    self.currentStyle.lineWidth = (self.currentStyle.lineWidth < 0.1) ? 0.1 : (self.currentStyle.lineWidth > 80) ? 80 : self.currentStyle.lineWidth;
    [self.stylePickerDelegate stylePickerView:self didPickStyle:self.currentStyle];
}

- (CAGradientLayer *)createMaskingGradientLayer;
{
    CAGradientLayer *layer = CAGradientLayer.layer;
    layer.masksToBounds = YES;
    return layer;
}
- (CAGradientLayer *)createSaturationLayer;
{
    CAGradientLayer *layer = [self createMaskingGradientLayer];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    return layer;
}

- (UILabel *)createValuesLabel;
{
    UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:10];
    label.numberOfLines = 0;
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    label.layer.shadowColor = UIColor.blackColor.CGColor;
    label.layer.shadowOffset = CGSizeZero;
    label.layer.shadowRadius = 3;
    label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    label.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    label.alpha = 0;
    return label;
}

- (CAGradientLayer *)createBrightnessLayer;
{
    CAGradientLayer *layer = [self createMaskingGradientLayer];
    layer.colors = @[(id)[UIColor colorWithHue:0 saturation:0 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1].CGColor];
    return layer;
}

- (CAGradientLayer *)createHueLayer;
{
    CAGradientLayer *layer = [self createMaskingGradientLayer];
    layer.colors = @[(id)[UIColor colorWithHue:0.0 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.2 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.4 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.6 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:0.8 saturation:1 brightness:1 alpha:1].CGColor,
                     (id)[UIColor colorWithHue:1.0 saturation:1 brightness:1 alpha:1].CGColor];
    return layer;
}

- (CAGradientLayer *)createAlphaLayer {
    CAGradientLayer *layer = [self createMaskingGradientLayer];
    layer.backgroundColor = UIColor.transparencyPattern.CGColor;
    return layer;
}

- (UIView *)createIndicatorView;
{
    UIView *newView = [UIView.alloc initWithFrame:CGRectMake(-1.5, 0, kHueBarWidth + 3, 7)];
    newView.backgroundColor = UIColor.clearColor;
    newView.layer.borderColor = UIColor.whiteColor.CGColor;
    newView.layer.borderWidth = 2;
    newView.layer.cornerRadius = 2;
    newView.layer.shadowColor = UIColor.blackColor.CGColor;
    newView.layer.shadowOpacity = 1;
    newView.layer.shadowRadius = 1;
    newView.layer.shadowOffset = CGSizeZero;
    newView.userInteractionEnabled = NO;
    return newView;
}

- (UIView *)createSaturationBrightnessIndicator;
{
    UIView *view = [UIView.alloc initWithFrame:CGRectMake(kHueBarWidth, 0, self.currentStyle.lineWidth, self.currentStyle.lineWidth)];
    view.layer.borderColor = UIColor.blackColor.CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = self.currentStyle.lineWidth / 2.f;
    view.layer.shadowColor = UIColor.blackColor.CGColor;
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 1;
    view.layer.shadowOffset = CGSizeZero;
    view.userInteractionEnabled = NO;
    view.clipsToBounds = NO;
    return view;
}

- (UIColor *)currentColor;
{
    return [UIColor colorWithHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:self.currentAlpha];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [UIView animateWithDuration:0.2 animations:^{ self.valuesLabel.alpha = 1; }];
    CGFloat xLocation = [touches.anyObject locationInView:self].x;
    self.touchArea = xLocation < kHueBarWidth ? TouchAreaHue : xLocation > self.bounds.size.width - kHueBarWidth ? TouchAreaAlpha : TouchAreaSaturationBrightness;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    CGFloat clampedX = 0;
    CGFloat clampedY = MIN(MAX([touches.anyObject locationInView:self].y, 0), self.bounds.size.height);
    CGFloat clampedYNormalized = clampedY / self.bounds.size.height;
    switch (self.touchArea) {
        case TouchAreaHue: {
            clampedX = kHueBarWidth / 2.f;
            self.currentHue = clampedYNormalized;
            self.hueIndicator.center = CGPointMake(kHueBarWidth / 2.f, clampedY);
            [self setNeedsDisplay];
            self.valuesLabel.text = [NSString stringWithFormat:@"hue: %i°", (int)(self.currentHue * 360.f)];
            break;
        }
        case TouchAreaAlpha: {
            clampedX = self.bounds.size.width - ( kHueBarWidth / 2.f);
            self.currentAlpha = clampedYNormalized;
            self.alphaIndicator.center = CGPointMake(self.bounds.size.width - ( kHueBarWidth / 2.f), clampedY);
            self.valuesLabel.text = [NSString stringWithFormat:@"alpha: %i%%", (int)(self.currentAlpha * 100.f)];
            break;
        }
        case TouchAreaSaturationBrightness:
        default: {
            clampedX = MIN(MAX(touches.anyObject.location.x, kHueBarWidth), self.bounds.size.width - kHueBarWidth);
            self.currentSaturation = (clampedX - kHueBarWidth) / (self.bounds.size.width - kHueBarWidth - kHueBarWidth);
            self.currentBrightness = 1.f - clampedYNormalized;
            self.saturationBrightnessIndicator.center = CGPointMake(clampedX, clampedY);
            [self setNeedsDisplay];
            self.valuesLabel.text = [NSString stringWithFormat:@"h: %i° • s: %i%%\nb: %i%% • a: %i%%",
                                     (int)(self.currentHue * 360.f), (int)(self.currentSaturation * 100.f),
                                     (int)(self.currentBrightness * 100.f),  (int)(self.currentAlpha * 100.f)];
            break;
        }
    }
    self.valuesLabel.center = CGPointMake(clampedX, clampedY - kValueLabelTouchOffset);
    [self configureSaturationBrightnessIndicator];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchesMoved:touches withEvent:event];

    [self.stylePickerDelegate stylePickerView:self didPickStyle:self.currentStyle];
    [UIView animateWithDuration:0.2 animations:^{ self.valuesLabel.alpha = 0; }];
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self alignIndicatorsWithValues];
}

- (void)setLineWidth:(CGFloat)lineWidth;
{
    self.currentStyle.lineWidth = lineWidth;
    CGPoint currentCenter = self.saturationBrightnessIndicator.center;
    CGRect currentFrame = self.saturationBrightnessIndicator.frame;
    currentFrame.size.width = lineWidth;
    currentFrame.size.height = lineWidth;
    self.saturationBrightnessIndicator.frame = currentFrame;
    self.saturationBrightnessIndicator.layer.cornerRadius = lineWidth / 2.f;
    self.saturationBrightnessIndicator.center = currentCenter;
}

- (void)alignIndicatorsWithValues;
{
    self.hueIndicator.center = CGPointMake(kHueBarWidth / 2.f, self.currentHue * self.bounds.size.height);
    self.saturationBrightnessIndicator.center = CGPointMake(kHueBarWidth + (self.currentSaturation * (self.bounds.size.width - kHueBarWidth - kHueBarWidth)),
                                                            (1 - self.currentBrightness) * self.bounds.size.height);
    self.alphaIndicator.center = CGPointMake(self.bounds.size.width - ( kHueBarWidth / 2.f), self.currentAlpha * self.bounds.size.height);
    [self configureSaturationBrightnessIndicator];
}

- (void)configureSaturationBrightnessIndicator;
{
    self.saturationBrightnessIndicator.backgroundColor = self.currentColor;
    self.saturationBrightnessIndicator.layer.shadowColor = [UIColor colorWithWhite:1.f - self.currentBrightness alpha:1.0].CGColor;
}

- (void)drawRect:(CGRect)rect;
{
    self.saturationLayer.colors = @[(id)[UIColor colorWithHue:self.currentHue saturation:0
                                                   brightness:1 alpha:1].CGColor,
                                    (id)[UIColor colorWithHue:self.currentHue saturation:1
                                                   brightness:1 alpha:1].CGColor];
    self.alphaLayer.colors = @[(id)[UIColor colorWithHue:self.currentHue saturation:self.currentSaturation
                                              brightness:self.currentBrightness alpha:0].CGColor,
                               (id)[UIColor colorWithHue:self.currentHue saturation:self.currentSaturation
                                              brightness:self.currentBrightness alpha:1].CGColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    self.hueLayer.frame = CGRectMake(0, 0, kHueBarWidth, rect.size.height);
    [self.hueLayer renderInContext:context];
    
    CGContextTranslateCTM(context, kHueBarWidth, 0);
    self.brightnessLayer.frame = CGRectMake(0, 0, rect.size.width - kHueBarWidth, rect.size.height);
    [self.brightnessLayer renderInContext:context];
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    self.saturationLayer.frame = CGRectMake(0, 0, rect.size.width - kHueBarWidth, rect.size.height);
    [self.saturationLayer renderInContext:context];
    
    CGContextTranslateCTM(context, rect.size.width - kHueBarWidth - kHueBarWidth, 0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    self.alphaLayer.frame = CGRectMake(0, 0, kHueBarWidth, rect.size.height);
    [self.alphaLayer renderInContext:context];
}

@end