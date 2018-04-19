
#import "UIColorPickerView.h"
#import "UIColor+Extras.h"
#import "UIImage+Extras.h"

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

@property (nonatomic) TouchArea touchArea;
@end

@implementation UIColorPickerView

static const CGFloat kHueBarWidth = 30;

- (instancetype)init; { if (!(self = [super init])) { return nil; } return [self commonInit]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder; { if (!(self = [super initWithCoder:aDecoder])) { return nil; } return [self commonInit]; }
- (instancetype)initWithFrame:(CGRect)frame; { if (!(self = [super initWithFrame:frame])) { return nil; } return [self commonInit]; }

- (instancetype)commonInit;
{
    self.saturationLayer = CAGradientLayer.layer;
    self.saturationLayer.masksToBounds = YES;
    self.saturationLayer.startPoint = CGPointMake(0, 0);
    self.saturationLayer.endPoint = CGPointMake(1, 0);
    
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
    
    self.saturationBrightnessIndicator = [UIView.alloc initWithFrame:CGRectMake(kHueBarWidth, 0, 20, 20)];
    self.saturationBrightnessIndicator.backgroundColor = UIColor.clearColor;
    self.saturationBrightnessIndicator.layer.borderColor = UIColor.blackColor.CGColor;
    self.saturationBrightnessIndicator.layer.borderWidth = 3;
    self.saturationBrightnessIndicator.layer.cornerRadius = 10;
    self.saturationBrightnessIndicator.layer.shadowColor = UIColor.blackColor.CGColor;
    self.saturationBrightnessIndicator.layer.shadowOpacity = 1;
    self.saturationBrightnessIndicator.layer.shadowRadius = 1;
    self.saturationBrightnessIndicator.layer.shadowOffset = CGSizeZero;
    [self addSubview:self.hueIndicator];
    [self addSubview:self.alphaIndicator];
    [self addSubview:self.saturationBrightnessIndicator];
    
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.cornerRadius = 3;
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
    CGFloat xLocation = [touches.anyObject locationInView:self].x;
    self.touchArea = xLocation < kHueBarWidth ? TouchAreaHue : xLocation > self.bounds.size.width - kHueBarWidth ? TouchAreaAlpha : TouchAreaSaturationBrightness;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    CGFloat clampedY = MIN(MAX([touches.anyObject locationInView:self].y, 0), self.bounds.size.height);
    CGFloat clampedYNormalized = clampedY / self.bounds.size.height;
    switch (self.touchArea) {
        case TouchAreaHue: {
            self.currentHue = clampedYNormalized;
            self.hueIndicator.center = CGPointMake(kHueBarWidth / 2.f, clampedY);
            [self setNeedsDisplay];
           break;
        }
        case TouchAreaAlpha: {
            self.currentAlpha = clampedYNormalized;
            self.alphaIndicator.center = CGPointMake(self.bounds.size.width - ( kHueBarWidth / 2.f), clampedY);
            break;
        }
        case TouchAreaSaturationBrightness:
        default: {
            CGFloat clampedX = MIN(MAX([touches.anyObject locationInView:self].x, kHueBarWidth), self.bounds.size.width - kHueBarWidth);
            self.currentSaturation = (clampedX - kHueBarWidth) / (self.bounds.size.width - kHueBarWidth);
            self.currentBrightness = 1.f - clampedYNormalized;
            self.saturationBrightnessIndicator.center = CGPointMake(clampedX, clampedY);
            [self setNeedsDisplay];
           break;
        }
    }
    self.saturationBrightnessIndicator.layer.borderColor = [self.currentColor colorWithAlphaComponent:1.0].CGColor;
    self.saturationBrightnessIndicator.layer.shadowColor = [UIColor colorWithWhite:1.f - self.currentBrightness alpha:1.0].CGColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [self touchesMoved:touches withEvent:event];
    [self.colorPickerDelegate colorPickerView:self didPickColor:self.currentColor];
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
