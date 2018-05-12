
#import "UIColorPickerView.h"
#import "UIColor+Extras.h"
#import "UIImage+Extras.h"
#import "UITouch+Extras.h"

typedef NS_ENUM(NSUInteger, TouchArea) {
    TouchAreaHue,
    TouchAreaSaturationBrightness,
    TouchAreaAlpha,
};

@interface UIColorPickerView()
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
@end

@implementation UIColorPickerView

static const CGFloat kHueBarWidth = 30;
static const CGFloat kValueLabelTouchOffset = 50;

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    self.lineWidth = 5;
    self.currentHue = 0;
    self.currentSaturation = 0.5;
    self.currentBrightness = 0.75;
    self.currentAlpha = 1;
    self.saturationLayer = CAGradientLayer.layer;
    self.saturationLayer.masksToBounds = YES;
    self.saturationLayer.startPoint = CGPointMake(0, 0);
    self.saturationLayer.endPoint = CGPointMake(1, 0);
    
    self.valuesLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.valuesLabel.textAlignment = NSTextAlignmentCenter;
    self.valuesLabel.font = [UIFont boldSystemFontOfSize:10];
    self.valuesLabel.numberOfLines = 0;
    self.valuesLabel.layer.cornerRadius = 4;
    self.valuesLabel.layer.masksToBounds = YES;
    self.valuesLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    self.valuesLabel.layer.shadowOffset = CGSizeZero;
    self.valuesLabel.layer.shadowRadius = 3;
    self.valuesLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    self.valuesLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.valuesLabel.alpha = 0;
    
    self.brightnessLayer = CAGradientLayer.layer;
    self.brightnessLayer.masksToBounds = YES;
    self.brightnessLayer.colors = @[(id)[UIColor colorWithHue:0 saturation:0 brightness:1 alpha:1].CGColor,
                                    (id)[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1].CGColor];
    
    self.hueLayer = CAGradientLayer.layer;
    self.hueLayer.masksToBounds = YES;
    self.hueLayer.colors = @[(id)[UIColor colorWithHue:0.0 saturation:1 brightness:1 alpha:1].CGColor,
                             (id)[UIColor colorWithHue:0.2 saturation:1 brightness:1 alpha:1].CGColor,
                             (id)[UIColor colorWithHue:0.4 saturation:1 brightness:1 alpha:1].CGColor,
                             (id)[UIColor colorWithHue:0.6 saturation:1 brightness:1 alpha:1].CGColor,
                             (id)[UIColor colorWithHue:0.8 saturation:1 brightness:1 alpha:1].CGColor,
                             (id)[UIColor colorWithHue:1.0 saturation:1 brightness:1 alpha:1].CGColor];
    
    self.alphaLayer = CAGradientLayer.layer;
    self.alphaLayer.masksToBounds = YES;
    self.alphaLayer.backgroundColor = UIColor.transparencyPattern.CGColor;
    
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = YES;
    
    self.hueIndicator = [self createIndicatorView];
    self.alphaIndicator = [self createIndicatorView];
    
    self.saturationBrightnessIndicator = [UIView.alloc initWithFrame:CGRectMake(kHueBarWidth, 0, self.lineWidth, self.lineWidth)];
    self.saturationBrightnessIndicator.layer.borderColor = UIColor.blackColor.CGColor;
    self.saturationBrightnessIndicator.layer.borderWidth = 1;
    self.saturationBrightnessIndicator.layer.cornerRadius = self.lineWidth / 2.f;
    self.saturationBrightnessIndicator.layer.shadowColor = UIColor.blackColor.CGColor;
    self.saturationBrightnessIndicator.layer.shadowOpacity = 1;
    self.saturationBrightnessIndicator.layer.shadowRadius = 1;
    self.saturationBrightnessIndicator.layer.shadowOffset = CGSizeZero;
    [self addSubview:self.hueIndicator];
    [self addSubview:self.alphaIndicator];
    [self addSubview:self.saturationBrightnessIndicator];
    [self addSubview:self.valuesLabel];
    
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeZero;
    self.contentMode = UIViewContentModeRedraw;
    
    return self;
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
    return newView;
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
    [self.colorPickerDelegate colorPickerView:self didPickColor:self.currentColor];
    [UIView animateWithDuration:0.2 animations:^{ self.valuesLabel.alpha = 0; }];
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self alignIndicatorsWithValues];
}

- (void)setLineWidth:(CGFloat)lineWidth;
{
    _lineWidth = lineWidth;
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
    self.hueLayer.frame = CGRectMake(0, 0, kHueBarWidth, rect.size.height);
    [self.hueLayer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), kHueBarWidth, 0);
    self.brightnessLayer.frame = CGRectMake(0, 0, rect.size.width - kHueBarWidth, rect.size.height);
    [self.brightnessLayer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
    self.saturationLayer.colors = @[(id)[UIColor colorWithHue:self.currentHue saturation:0 brightness:1 alpha:1].CGColor,
                                    (id)[UIColor colorWithHue:self.currentHue saturation:1 brightness:1 alpha:1].CGColor];
    self.saturationLayer.frame = CGRectMake(0, 0, rect.size.width - kHueBarWidth, rect.size.height);
    [self.saturationLayer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), rect.size.width - kHueBarWidth - kHueBarWidth, 0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    self.alphaLayer.frame = CGRectMake(0, 0, kHueBarWidth, rect.size.height);
    self.alphaLayer.colors = @[(id)[UIColor colorWithHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:0].CGColor,
                               (id)[UIColor colorWithHue:self.currentHue saturation:self.currentSaturation brightness:self.currentBrightness alpha:1].CGColor];
    [self.alphaLayer renderInContext:UIGraphicsGetCurrentContext()];
    
}

@end
