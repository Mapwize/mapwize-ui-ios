#import "MWZSceneCoordinator.h"

@implementation MWZSceneCoordinator

-(instancetype) initWithContainerView:(UIView*)containerView {
    self = [super init];
    if (self) {
        _containerView = containerView;
    }
    return self;
}

-(void) setDefaultScene:(MWZDefaultScene*)defaultScene {
    _defaultScene = defaultScene;
    [_defaultScene addTo:_containerView];
}

-(void) setSearchScene:(MWZSearchScene*)searchScene {
    _searchScene = searchScene;
    [_searchScene addTo:_containerView];
    [_searchScene setHidden:YES];
}

-(void) setDirectionScene:(MWZDirectionScene*)directionScene {
    _directionScene = directionScene;
    [_directionScene addTo:_containerView];
    [_directionScene setHidden:YES];
}

-(void) transitionFromDefaultToSearch {
    [self.searchScene setHidden:NO];
    int height = 10000;
    float alpha = 1.0f;
    [self.searchScene.backgroundView setAlpha:0.0f];
    [self.searchScene.searchQueryBar setAlpha:0.0f];
    [self.searchScene.searchQueryBar setTransform:CGAffineTransformMakeTranslation(0,0)];
    [self.searchScene.backgroundView setTransform:CGAffineTransformMakeTranslation(0,0)];
    [self.searchScene.searchQueryBar.backButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene.backgroundView setAlpha:alpha];
        [self.searchScene.searchQueryBar setAlpha:alpha];
    } completion:^(BOOL finished) {
        [self.searchScene.searchQueryBar.searchTextField becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchScene.resultContainerViewHeightConstraint.constant = height;
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [self.searchScene.searchQueryBar.backButton setUserInteractionEnabled:YES];
        }];
    }];
}

-(void) transitionFromSearchToDefault {
    int height = 0;
    double alpha = 0.0f;
    [self.searchScene.backgroundView setAlpha:1.0f];
    [self.searchScene.searchQueryBar.searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchScene.resultContainerViewHeightConstraint.constant = height;
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene.backgroundView setAlpha:alpha];
            [self.searchScene.searchQueryBar setAlpha:alpha];
        } completion:^(BOOL finished) {
            [self.searchScene setHidden:YES];
            [self.searchScene clearSearch];
        }];
    }];
}

-(void) transitionFromDefaultToDirection {
    [self.directionScene setHidden:NO];
    [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,-self.directionScene.directionHeader.frame.size.height)];
    [self.containerView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.directionScene.topConstraintViewMarginTop.constant = self.directionScene.directionHeader.frame.size.height;
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.defaultScene.bottomInfoView setTransform:CGAffineTransformMakeTranslation(0,self.defaultScene.bottomInfoView.frame.size.height)];
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void) transitionFromDirectionToDefault {
    [self.containerView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.directionScene.topConstraintViewMarginTop.constant = 0.0f;
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,-self.directionScene.directionHeader.frame.size.height)];
        [self.containerView layoutIfNeeded];
        [self.defaultScene.bottomInfoView setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        [self.directionScene setHidden:YES];
    }];
}

-(void) transitionFromDirectionToSearch {
    [self.searchScene setHidden:NO];
    [self.searchScene.backgroundView setAlpha:1.0];
    [self.searchScene.searchQueryBar setAlpha:1.0];
    self.searchScene.resultContainerViewHeightConstraint.constant = 10000;
    [self.containerView layoutIfNeeded];
    [self.searchScene.backgroundView setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
    [self.searchScene.resultContainerView setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
    [self.searchScene.searchQueryBar setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
    [self.searchScene.searchQueryBar.backButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene.searchQueryBar setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.searchScene.backgroundView setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.searchScene.resultContainerView setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(-self.containerView.frame.size.width,0)];
    } completion:^(BOOL finished) {
        [self.searchScene.searchQueryBar.searchTextField becomeFirstResponder];
        [self.searchScene.searchQueryBar.backButton setUserInteractionEnabled:YES];
    }];
}

-(void) transitionFromSearchToDirection {
    [self.searchScene.searchQueryBar.searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene.searchQueryBar setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
        [self.searchScene.backgroundView setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
        [self.searchScene.resultContainerView setTransform:CGAffineTransformMakeTranslation(self.containerView.frame.size.width,0)];
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        [self.searchScene setHidden:YES];
    }];
}

@end
