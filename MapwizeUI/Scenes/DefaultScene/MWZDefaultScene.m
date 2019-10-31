#import "MWZDefaultScene.h"
#import "MWZUIConstants.h"

@implementation MWZDefaultScene

- (void)addTo:(UIView *)view {
    self.menuBar = [[MWZMapViewMenuBar alloc] initWithFrame:CGRectZero];
    self.menuBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuBar.delegate = self;
    [view addSubview:self.menuBar];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right - MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:view.safeAreaInsets.left + MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    }
    
    self.bottomInfoView = [[MWZComponentBottomInfoView alloc] initWithColor:[UIColor greenColor]];
    self.bottomInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomInfoView.delegate = self;
    [view addSubview:self.bottomInfoView];
    
    [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

- (void) setDirectionButtonHidden:(BOOL) isHidden {
    if (isHidden) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.menuBar.directionButton setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.menuBar.directionButton setHidden:isHidden];
        }];
    }
    else {
        [self.menuBar.directionButton setAlpha:0.0];
        [self.menuBar.directionButton setHidden:isHidden];
        [UIView animateWithDuration:0.3 animations:^{
            [self.menuBar.directionButton setAlpha:1.0];
        }];
    }
}

- (void) setSearchBarTitleForVenue:(NSString*) venueName {
    if (venueName || venueName.length == 0) {
        self.menuBar.searchQueryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Search in %@...", ""), venueName];
    }
    else {
        self.menuBar.searchQueryLabel.text = NSLocalizedString(@"Search a venue...", "");
    }
}

- (void) setHidden:(BOOL) hidden {
    [self.menuBar setHidden:hidden];
}

- (void) showContent:(id<MWZObject>) object language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
    if ([object isKindOfClass:MWZPlace.class]) {
        [self.bottomInfoView selectContentWithPlace:(MWZPlace*)object language:language showInfoButton:showInfoButton];
    }
    if ([object isKindOfClass:MWZPlacelist.class]) {
        [self.bottomInfoView selectContentWithPlaceList:(MWZPlacelist*)object language:language showInfoButton:showInfoButton];
    }
}

- (void) hideContent {
    [self.bottomInfoView unselectContent];
}

#pragma mark MWZMapViewMenuBarDelegate
- (void)didTapOnDirectionButton {
    [_delegate didTapOnDirectionButton];
}

- (void)didTapOnMenuButton {
    [_delegate didTapOnMenuButton];
}

- (void)didTapOnSearchButton {
    [_delegate didTapOnSearchButton];
}

#pragma mark MWZComponentBottomInfoViewDelegate
- (void)didPressDirection {
    
}

- (void)didPressInformation {
    
}

@end
