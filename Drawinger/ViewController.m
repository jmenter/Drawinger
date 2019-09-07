
#import "ViewController.h"
#import "UIDrawingView.h"
#import "UIColorPickerView.h"

@interface ViewController()<UIColorPickerViewDelegate>

@property (nonatomic, nonnull) IBOutlet UIDrawingView *drawingView;
@property (nonatomic, nonnull) IBOutlet UIColorPickerView *colorPickerView;
@property (nonatomic, nonnull) IBOutlet UISlider *lineWidthSlider;

@end


@implementation ViewController

- (BOOL)prefersStatusBarHidden; { return YES; }

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self resetWasTapped:nil];
}

- (IBAction)resetWasTapped:(id)sender;
{
    [self.drawingView reset];
    self.drawingView.drawingColor = self.colorPickerView.currentColor;
    self.drawingView.lineWidth = self.lineWidthSlider.value;
}

- (IBAction)lineWeightSliderDidChange:(nonnull UISlider *)sender;
{
    self.drawingView.lineWidth = sender.value;
    self.colorPickerView.lineWidth = sender.value;
}

- (void)colorPickerView:(nonnull UIColorPickerView *)colorPickerView didPickColor:(nonnull UIColor *)color;
{
    self.drawingView.drawingColor = color;
}

@end
