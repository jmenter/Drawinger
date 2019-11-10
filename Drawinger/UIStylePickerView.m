
#import "UIStylePickerView.h"
#import "Extras.h"

typedef NS_ENUM(NSUInteger, TouchArea) {
    TouchAreaHue,
    TouchAreaSaturationBrightness,
    TouchAreaAlpha,
};


@interface UIStylePickerView ()

@property (nonatomic) CGFloat currentHue;
@property (nonatomic) CGFloat currentSaturation;
@property (nonatomic) CGFloat currentBrightness;
@property (nonatomic) CGFloat currentAlpha;
@property (nonatomic) CGFloat currentLineWidth;

@property (nonatomic) CAGradientLayer *hueLayer;
@property (nonatomic) CAGradientLayer *saturationLayer;
@property (nonatomic) CAGradientLayer *brightnessLayer;
@property (nonatomic) CAGradientLayer *alphaLayer;

@property (nonatomic) UIView *hueIndicator;
@property (nonatomic) UIView *saturationBrightnessIndicator;
@property (nonatomic) UIView *alphaIndicator;

@property (nonatomic) UILabel *valuesLabel;
@property (nonatomic) TouchArea touchArea;

@end

@implementation UIStylePickerView

static const CGFloat kHueBarWidth = 30;
static const CGFloat kValueLabelTouchOffset = 50;

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    [self configureDefaults];
    [self initializeViewsAndLayers];
    
    [self addSubview:self.hueIndicator];
    [self addSubview:self.alphaIndicator];
    [self addSubview:self.saturationBrightnessIndicator];
    [self addSubview:self.valuesLabel];
    
    [self addGestureRecognizers];
    
    return self;
}

- (void)configureDefaults;
{
    self.currentHue = 0;
    self.currentSaturation = 0.5;
    self.currentBrightness = 0.75;
    self.currentAlpha = 1;
    self.currentLineWidth = 20;

    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeZero;

    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
}

- (void)initializeViewsAndLayers;
{
    self.saturationLayer = CAGradientLayer.saturationLayer;
    self.brightnessLayer = CAGradientLayer.brightnessLayer;
    self.hueLayer = CAGradientLayer.hueLayer;
    self.alphaLayer = CAGradientLayer.alphaLayer;

    self.hueIndicator = [self createIndicatorView];
    self.alphaIndicator = [self createIndicatorView];
    self.saturationBrightnessIndicator = [self createSaturationBrightnessIndicator];
    self.valuesLabel = [self createValuesLabel];
}

- (void)addGestureRecognizers;
{
    UIPinchGestureRecognizer *pinchGr = [UIPinchGestureRecognizer.alloc initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGr];

    UIPanGestureRecognizer *panGr = [UIPanGestureRecognizer.alloc initWithTarget:self action:@selector(handlePan:)];
    panGr.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:panGr];
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

- (void)handlePan:(UIPanGestureRecognizer *)panGR;
{
    static CGPoint previousLocation;
    if (panGR.state == UIGestureRecognizerStateBegan) {
        previousLocation = panGR.location;
    }
    CGPoint currentLocation = panGR.location;
    [self.stylePickerDelegate stylePickerView:self didRequestMove:CGPointSubtractPoints(currentLocation, previousLocation)];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGR;
{
    static CGFloat initialLineWidth;
    if (pinchGR.state == UIGestureRecognizerStateBegan) {
        initialLineWidth = self.currentLineWidth;
    }
    self.currentLineWidth = CGFloatClamp(initialLineWidth * pinchGR.scale, 0.1, 80);
    [self.stylePickerDelegate stylePickerViewDidPickAStyle:self];
    [self setNeedsDisplay];
}

- (UIStyle *)currentStyle;
{
    return [UIStyle styleWithColor:self.currentColor lineWidth:self.currentLineWidth];
}

- (UIColor *)currentColor;
{
    return [UIColor colorWithHue:self.currentHue saturation:self.currentSaturation
                      brightness:self.currentBrightness alpha:self.currentAlpha];
}

- (void)setCurrentLineWidth:(CGFloat)lineWidth;
{
    if (_currentLineWidth != lineWidth) {
        _currentLineWidth = lineWidth;
        CGPoint currentCenter = self.saturationBrightnessIndicator.center;
        CGRect currentFrame = self.saturationBrightnessIndicator.frame;
        currentFrame.size.width = lineWidth;
        currentFrame.size.height = lineWidth;
        self.saturationBrightnessIndicator.frame = currentFrame;
        self.saturationBrightnessIndicator.layer.cornerRadius = lineWidth / 2.f;
        self.saturationBrightnessIndicator.center = currentCenter;
    }
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

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    if (touches.count > 1) { return; }

    [self.valuesLabel fadeIn];
    CGFloat xLocation = [touches.anyObject locationInView:self].x;
    self.touchArea = xLocation < kHueBarWidth ? TouchAreaHue : xLocation > self.bounds.size.width - kHueBarWidth ? TouchAreaAlpha : TouchAreaSaturationBrightness;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    if (touches.count > 1) { return; }
    
    CGFloat clampedX = 0;
    CGFloat clampedY = MIN(MAX([touches.anyObject locationInView:self].y, 0), self.bounds.size.height);
    CGFloat value = clampedY / self.bounds.size.height;
    switch (self.touchArea) {
        case TouchAreaHue: {
            clampedX = kHueBarWidth / 2.f;
            [self handleHueAreaTouch:clampedY value:value];
            break;
        }
        case TouchAreaAlpha: {
            clampedX = self.bounds.size.width - ( kHueBarWidth / 2.f);
            [self handleAlphaAreaTouch:clampedY value:value];
            break;
        }
        case TouchAreaSaturationBrightness:
        default: {
            clampedX = MIN(MAX(touches.anyObject.location.x, kHueBarWidth), self.bounds.size.width - kHueBarWidth);
            [self handleSaturationAreaTouch:clampedX clampedY:clampedY value:value];
            break;
        }
    }
    self.valuesLabel.center = CGPointMake(clampedX, clampedY - kValueLabelTouchOffset);
    [self configureSaturationBrightnessIndicator];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    if (touches.count > 1) { return; }
    
    [self touchesMoved:touches withEvent:event];
    [self.stylePickerDelegate stylePickerViewDidPickAStyle:self];
    [self.valuesLabel fadeOut];
}

- (void)handleHueAreaTouch:(CGFloat)clampedY value:(CGFloat)value;
{
    self.currentHue = value;
    [UIView animateWithDuration:0.1 animations:^{
        self.hueIndicator.center = CGPointMake(kHueBarWidth / 2.f, clampedY);
    }];
    self.valuesLabel.text = self.currentHueDescription;
}

- (void)handleAlphaAreaTouch:(CGFloat)clampedY value:(CGFloat)value;
{
    self.currentAlpha = value;
    [UIView animateWithDuration:0.1 animations:^{
        self.alphaIndicator.center = CGPointMake(self.bounds.size.width - ( kHueBarWidth / 2.f), clampedY);
    }];
    self.valuesLabel.text = self.currentAlphaDescription;
}

- (void)handleSaturationAreaTouch:(CGFloat)clampedX clampedY:(CGFloat)clampedY value:(CGFloat)value;
{
    self.currentSaturation = (clampedX - kHueBarWidth) / (self.bounds.size.width - kHueBarWidth - kHueBarWidth);
    self.currentBrightness = 1.f - value;
    [UIView animateWithDuration:0.1 animations:^{
        self.saturationBrightnessIndicator.center = CGPointMake(clampedX, clampedY);
    }];
    self.valuesLabel.text = self.currentSaturationDescription;
}

- (NSString *)currentHueDescription;
{
    return [NSString stringWithFormat:@"hue: %i°", (int)(self.currentHue * 360.f)];
}

- (NSString *)currentAlphaDescription;
{
    return [NSString stringWithFormat:@"alpha: %i%%", (int)(self.currentAlpha * 100.f)];
}

- (NSString *)currentSaturationDescription;
{
    return [NSString stringWithFormat:@"saturation: %i%%\nbrightness: %i%%", (int)(self.currentSaturation * 100.f), (int)(self.currentBrightness * 100.f)];
}

#pragma mark - UIView

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self alignIndicatorsWithValues];
}

- (void)drawRect:(CGRect)rect;
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.saturationLayer.colors = @[(id)[UIColor colorWithHue:self.currentHue saturation:0 brightness:1 alpha:1].CGColor,
                                    (id)[UIColor colorWithHue:self.currentHue saturation:1 brightness:1 alpha:1].CGColor];
    
    self.alphaLayer.colors = @[(id)[self.currentColor colorWithAlphaComponent:0].CGColor,
                               (id)[self.currentColor colorWithAlphaComponent:1].CGColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    self.hueLayer.frame = CGRectMake(0, 0, kHueBarWidth, height);
    [self.hueLayer renderInContext:context];
    
    CGContextTranslateCTM(context, kHueBarWidth, 0);
    self.brightnessLayer.frame = CGRectMake(0, 0, width - kHueBarWidth, height);
    [self.brightnessLayer renderInContext:context];
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    self.saturationLayer.frame = CGRectMake(0, 0, width - kHueBarWidth, height);
    [self.saturationLayer renderInContext:context];
    
    CGContextTranslateCTM(context, width - kHueBarWidth - kHueBarWidth, 0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    self.alphaLayer.frame = CGRectMake(0, 0, kHueBarWidth, height);
    [self.alphaLayer renderInContext:context];
}

@end
