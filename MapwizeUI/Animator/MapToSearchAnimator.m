#import "MapToSearchAnimator.h"
#import "MWZSearchViewController.h"
@implementation MapToSearchAnimator {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.4;
        _presenting = YES;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView* containerView = transitionContext.containerView;
    MWZSearchViewController* searchVC;
    int height;
    float alpha;
    if (_presenting) {
        searchVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        height = 10000;
        alpha = 1.0f;
        [searchVC.backgroundView setAlpha:0.0f];
        [containerView addSubview:searchVC.view];
        [UIView animateWithDuration:_duration/3 animations:^{
            [searchVC.backgroundView setAlpha:alpha];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.duration*2/3 animations:^{
                searchVC.tableViewHeightConstraint.constant = height;
                [searchVC.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }];
    }
    else {
        searchVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        height = 0;
        alpha = 0.0f;
        [searchVC.backgroundView setAlpha:1.0f];
        [containerView addSubview:[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view];
        [containerView addSubview:searchVC.view];
        [UIView animateWithDuration:self.duration*2/3 animations:^{
            searchVC.tableViewHeightConstraint.constant = height;
            [searchVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.duration/3 animations:^{
                [searchVC.backgroundView setAlpha:alpha];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }];
    }
    [searchVC.view layoutIfNeeded];
    
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

@end
