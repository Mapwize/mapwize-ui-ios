#import "MWZMapViewController.h"
#import "MWZSearchViewController.h"
#import "MapToSearchAnimator.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"

@interface MWZMapViewController ()

@property (nonatomic) MapToSearchAnimator* mapToSearchAnimator;
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
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.mapView];
    self.mapToSearchAnimator = [[MapToSearchAnimator alloc] init];

    self.defaultScene = [[MWZDefaultScene alloc] initWithFrame:self.view.frame];
    self.defaultScene.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    //[self.defaultScene setHidden:YES];
    self.defaultScene.delegate = self;
    [self.view addSubview:self.defaultScene];
    
    self.searchScene = [[MWZSearchScene alloc] initWithFrame:self.view.frame];
    self.searchScene.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.searchScene setHidden:YES];
    self.searchScene.delegate = self;
    [self.view addSubview:self.searchScene];
    
}

- (void) mapToSearchTransition {
    [self.searchScene setHidden:NO];
    int height = 10000;
    float alpha = 1.0f;
    [self.searchScene.backgroundView setAlpha:0.0f];
    [self.searchScene.searchQueryBar setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene.backgroundView setAlpha:alpha];
        [self.searchScene.searchQueryBar setAlpha:alpha];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchScene.resultContainerViewHeightConstraint.constant = height;
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void) searchToMapTransition {
    int height = 0;
    double alpha = 0.0f;
    [self.searchScene.backgroundView setAlpha:1.0f];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchScene.resultContainerViewHeightConstraint.constant = height;
        [self.searchScene layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene.backgroundView setAlpha:alpha];
            [self.searchScene.searchQueryBar setAlpha:alpha];
        } completion:^(BOOL finished) {
            [self.searchScene setHidden:YES];
        }];
    }];
}

- (void) directionToSearchTransition {
    [self.searchScene setHidden:NO];
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
    }];
}

- (void) searchToDirectionTransition {
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width,0)];
        [self.defaultScene setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.searchScene setHidden:YES];
        }];
    }];
}

#pragma mark MWZMapViewMenuBarDelegate
- (void) didTapOnSearchButton {
    [self mapToSearchTransition];
}

- (void)didTapOnBackButton {
    [self searchToMapTransition];
    //[self searchToDirectionTransition];
}

- (void)searchQueryDidChange:(NSString *)query {
    
}

- (void) didTapOnMenuButton {
    
}

- (void) didTapOnDirectionButton {
    [self directionToSearchTransition];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.mapToSearchAnimator.presenting = YES;
    return self.mapToSearchAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.mapToSearchAnimator.presenting = NO;
    return self.mapToSearchAnimator;
}



@end
