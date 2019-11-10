
#import "DrawingerViewController.h"
#import "UIDrawingView.h"
#import "UIStylePickerView.h"
#import "Extras.h"

@interface DrawingerViewController (Private) <UIStylePickerDelegate>

@property (nonatomic) IBOutlet UIDrawingView *drawingView;
@property (nonatomic) IBOutlet UIStylePickerView *colorPickerView;

@end

@implementation DrawingerViewController

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden; { return YES; }

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self resetWasTapped:nil];
}

- (IBAction)resetWasTapped:(id)sender;
{
    [self.drawingView resetWithDrawingStyle:self.colorPickerView.currentStyle];
}

#pragma mark - UIStylePickerViewDelegate

- (void)stylePickerViewDidPickAStyle:(UIStylePickerView *)stylePickerView;
{
    self.drawingView.currentDrawingStyle = stylePickerView.currentStyle;
}

- (void)stylePickerView:(UIStylePickerView *)colorPickerView didRequestMove:(CGPoint)amount;
{
    colorPickerView.center = CGPointQuantize(CGPointAddPoints(colorPickerView.center, amount));
}

@end
