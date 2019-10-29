#import "MWZMapViewController.h"
#import "MWZSearchViewController.h"
#import "MapToSearchAnimator.h"

@interface MWZMapViewController ()

@property (nonatomic) MapToSearchAnimator* mapToSearchAnimator;

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

    self.menuBar = [[MWZMapViewMenuBar alloc] initWithFrame:CGRectZero];
    self.menuBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuBar.delegate = self;
    [self.view addSubview:self.menuBar];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.view.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.view.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
}

- (void) didTapOnSearchButton {
    MWZSearchViewController* searchVC = [[MWZSearchViewController alloc] init];
    [searchVC setModalPresentationStyle:UIModalPresentationFullScreen];
    searchVC.transitioningDelegate = self;
    [self presentViewController:searchVC animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.mapToSearchAnimator.presenting = YES;
    return self.mapToSearchAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.mapToSearchAnimator.presenting = NO;
    return self.mapToSearchAnimator;
}

@end
