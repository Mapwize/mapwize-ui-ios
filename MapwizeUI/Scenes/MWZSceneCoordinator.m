#import "MWZSceneCoordinator.h"

@implementation MWZSceneCoordinator

-(instancetype) initWithContainerView:(UIView*) containerView {
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
    [self.searchScene.searchQueryBar.backButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene.backgroundView setAlpha:alpha];
        [self.searchScene.searchQueryBar setAlpha:alpha];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchScene.resultContainerViewHeightConstraint.constant = height;
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.searchScene.searchQueryBar.searchTextField becomeFirstResponder];
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
    [UIView animateWithDuration:0.3 animations:^{
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void) transitionFromDirectionToDefault {
    [UIView animateWithDuration:0.3 animations:^{
        [self.directionScene.directionHeader setTransform:CGAffineTransformMakeTranslation(0,-self.directionScene.directionHeader.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.directionScene setHidden:YES];
    }];
}

@end
