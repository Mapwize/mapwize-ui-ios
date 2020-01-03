#import "ViewController.h"
#import <MapwizeUI/MapwizeUI.h>

@interface ViewController () <MWZUIViewDelegate>

@property (nonatomic, retain) MWZUIView* mapwizeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MWZUIOptions* opts = [[MWZUIOptions alloc] init];
    MWZUISettings* settings = [[MWZUISettings alloc] init];
    
    self.mapwizeView = [[MWZUIView alloc] initWithFrame:self.view.frame
                                              mapwizeOptions:opts
                                                  uiSettings:settings];
    self.mapwizeView.delegate = self;
    self.mapwizeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mapwizeView];
    [[NSLayoutConstraint constraintWithItem:self.mapwizeView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.mapwizeView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.mapwizeView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.mapwizeView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

- (void)mapwizeView:(MWZUIView *)mapwizeView didTapOnPlaceInformationButton:(MWZPlace *)place {
    NSLog(@"didTapOnPlaceInformations");
    NSString* message = [NSString stringWithFormat:@"Click on the place information button %@", place.translations[0].title];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeView:(MWZUIView *)mapwizeView didTapOnPlaceListInformationButton:(MWZPlacelist *)placeList {
    NSLog(@"didTapOnPlaceListInformations");
    NSString* message = [NSString stringWithFormat:@"Click on the placelist information button %@", placeList.translations[0].title];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeViewDidTapOnFollowWithoutLocation:(MWZUIView *)mapwizeView {
    NSLog(@"mapwizeViewDidTapOnFollowWithoutLocation");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:@"Click on the follow user mode button but no location has been found"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeViewDidTapOnMenu:(MWZUIView *)mapwizeView {
    NSLog(@"mapwizeViewDidTapOnMenu");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                    message:@"Click on the menu"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) mapwizeViewDidLoad:(MWZUIView*) mapwizeView {
    NSLog(@"mapwizeViewDidLoad");
}

- (BOOL) mapwizeView:(MWZUIView *)mapwizeView shouldShowInformationButtonFor:(id<MWZObject>)mapwizeObject {
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        return YES;
    }
    return NO;
}

@end
