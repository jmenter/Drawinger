
#import "ViewController.h"
#import "UIDrawingView.h"
#import "UIColorPickerView.h"

@interface ViewController()<UIColorPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIDrawingView *drawingView;
@property (weak, nonatomic) IBOutlet UIColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;

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

- (IBAction)lineWeightSliderDidChange:(UISlider *)sender;
{
    self.drawingView.lineWidth = sender.value;
}

- (void)colorPickerView:(UIColorPickerView *)colorPickerView didPickColor:(UIColor *)color;
{
    self.drawingView.drawingColor = color;
}

@end
