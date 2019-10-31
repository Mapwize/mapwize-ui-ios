#import "MWZMapViewController.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"

@interface MWZMapViewController ()

@property (nonatomic) MWZSceneCoordinator* sceneCoordinator;
@property (nonatomic) MWZSearchScene* searchScene;
@property (nonatomic) MWZDefaultScene* defaultScene;

@end

@implementation MWZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) initialize {
    
    self.mapView = [[MWZMapView alloc] initWithFrame:self.view.frame options:[[MWZOptions alloc] init]];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.mapView];

    self.sceneCoordinator = [[MWZSceneCoordinator alloc] initWithContainerView:self.view];
    
    self.defaultScene = [[MWZDefaultScene alloc] init];
    self.defaultScene.delegate = self;
    self.sceneCoordinator.defaultScene = self.defaultScene;
    
    self.searchScene = [[MWZSearchScene alloc] init];
    self.searchScene.delegate = self;
    self.sceneCoordinator.searchScene = self.searchScene;
    
}

- (void) mapToSearchTransition {
    [self.sceneCoordinator transitionFromDefaultToSearch];
}

- (void) searchToMapTransition {
    [self.sceneCoordinator transitionFromSearchToDefault];
}

- (void) directionToSearchTransition {
    /*[self.searchScene setHidden:NO];
    [self.searchScene.backgroundView setAlpha:1.0];
    [self.searchScene.searchQueryBar setAlpha:1.0];
    [self.searchScene setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width,0)];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.defaultScene setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width,0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];*/
}

- (void) searchToDirectionTransition {
    /*[UIView animateWithDuration:0.3 animations:^{
        [self.searchScene setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width,0)];
        [self.defaultScene setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.searchScene setHidden:YES];
        }];
    }];*/
}

#pragma mark MWZMapViewDelegate
- (void)mapView:(MWZMapView *_Nonnull)mapView didTap:(MWZClickEvent *_Nonnull)clickEvent {
    switch (clickEvent.eventType) {
        case MWZClickEventTypeVenueClick:
            [self.mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark MWZDefaultSceneDelegate
- (void) didTapOnSearchButton {
    [self mapToSearchTransition];
}

- (void) didTapOnMenuButton {
    
}

- (void) didTapOnDirectionButton {
    [self directionToSearchTransition];
}

#pragma mark MWZSearchSceneDelegate
- (void)didTapOnBackButton {
    [self searchToMapTransition];
}

- (void)searchQueryDidChange:(NSString *)query {
    
}


@end
