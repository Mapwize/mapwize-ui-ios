#import "ViewController.h"
#import <MapwizeUI/MapwizeUI.h>

@interface ViewController () <MWZMapwizeViewDelegate>

@property (nonatomic, retain) MWZMapwizeView* mapwizeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MWZUIOptions* opts = [[MWZUIOptions alloc] init];
    opts.centerOnPlaceId = @"5bc49413bf0ed600114db212";   // Center on Mapwize
    //opts.centerOnVenueId = @"56b20714c3fa800b00d8f0b5";   // Center on Euratechnologies
    //opts.centerOnLocation = [[MWZLatLngFloor alloc] initWithLatitude:50.6331 longitude:3.0198 floor:@0]; // Center on marker in Euratechnologies
    
    MWZMapwizeViewUISettings* settings = [[MWZMapwizeViewUISettings alloc] init];
    settings.followUserButtonIsHidden = NO;
    settings.menuButtonIsHidden = NO;
    //settings.mainColor = [UIColor orangeColor];           // Change main color to Orange
    
    self.mapwizeView = [[MWZMapwizeView alloc] initWithFrame:self.view.frame
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

- (void)mapwizeView:(MWZMapwizeView *)mapwizeView didTapOnPlaceInformationButton:(MWZPlace *)place {
    NSLog(@"didTapOnPlaceInformations");
    NSString* message = [NSString stringWithFormat:@"Click on the place information button %@", place.translations[0].title];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeView:(MWZMapwizeView *)mapwizeView didTapOnPlaceListInformationButton:(MWZPlaceList *)placeList {
    NSLog(@"didTapOnPlaceListInformations");
    NSString* message = [NSString stringWithFormat:@"Click on the placelist information button %@", placeList.translations[0].title];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeViewDidTapOnFollowWithoutLocation:(MWZMapwizeView *)mapwizeView {
    NSLog(@"mapwizeViewDidTapOnFollowWithoutLocation");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                   message:@"Click on the follow user mode button but no location has been found"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapwizeViewDidTapOnMenu:(MWZMapwizeView *)mapwizeView {
    NSLog(@"mapwizeViewDidTapOnMenu");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                    message:@"Click on the menu"
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) mapwizeViewDidLoad:(MWZMapwizeView*) mapwizeView {
    NSLog(@"mapwizeViewDidLoad");
}

- (BOOL) mapwizeView:(MWZMapwizeView *)mapwizeView shouldShowInformationButtonFor:(id<MWZObject>)mapwizeObject {
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        return YES;
    }
    return NO;
}

@end
