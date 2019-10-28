
#import "ViewController.h"
#import "UIDrawingView.h"
#import "UIStylePickerView.h"
#import "Extras.h"

@interface ViewController()<UIStylePickerViewDelegate>

@property (nonatomic, nonnull) IBOutlet UIDrawingView *drawingView;
@property (nonatomic, nonnull) IBOutlet UIStylePickerView *colorPickerView;

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
    self.drawingView.currentDrawingStyle = self.colorPickerView.currentStyle;
}

- (void)stylePickerViewDidPickStyle:(UIStylePickerView *)stylePickerView;
{
    self.drawingView.currentDrawingStyle = stylePickerView.currentStyle;
}

- (void)stylePickerView:(UIStylePickerView *)colorPickerView didRequestMove:(CGPoint)amount;
{
    colorPickerView.center = CGPointQuantize(CGPointAddPoints(colorPickerView.center, amount));
}

@end
