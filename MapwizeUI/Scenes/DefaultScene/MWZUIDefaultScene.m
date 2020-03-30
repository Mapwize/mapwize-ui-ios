#import "MWZUIDefaultScene.h"

@implementation MWZUIDefaultScene

- (instancetype) initWith:(UIColor*) mainColor menuIsHidden:(BOOL) menuIsHidden {
    self = [super init];
    if (self) {
        _sceneProperties = [[MWZUIDefaultSceneProperties alloc] init];
        _mainColor = mainColor;
        _menuIsHidden = menuIsHidden;
    }
    return self;
}

- (instancetype)initWith:(UIColor *)mainColor {
    self = [super init];
    if (self) {
        _sceneProperties = [[MWZUIDefaultSceneProperties alloc] init];
        _mainColor = mainColor;
        _menuIsHidden = NO;
    }
    return self;
}


- (void)addTo:(UIView *)view {
    self.menuBar = [[MWZUIMapViewMenuBar alloc] initWithFrame:CGRectZero];
    [self.menuBar.menuButton setHidden:_menuIsHidden];
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
                                       constant:-view.safeAreaInsets.right - 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:view.safeAreaInsets.left + 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
    }
    
    self.bottomInfoView = [[MWZUIBottomInfoView alloc] initWithColor:self.mainColor];
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

- (UIView*) getTopViewToConstraint {
    return self.menuBar;
}

- (UIView*) getBottomViewToConstraint {
    return self.bottomInfoView;
}

- (void) setSceneProperties:(MWZUIDefaultSceneProperties *)sceneProperties {
    
    if (sceneProperties.venue) {
        [self setSearchBarTitleForVenue:[sceneProperties.venue titleForLanguage:sceneProperties.language] loading:sceneProperties.venueLoading];
        if (!_sceneProperties.venue) {
            [self setDirectionButtonHidden:NO];
        }
        if (sceneProperties.selectedContent) {
            [self showContent:sceneProperties.selectedContent
                     language:sceneProperties.language
               showInfoButton:!sceneProperties.infoButtonHidden];
        }
        else if (_sceneProperties.selectedContent) {
            [self hideContent];
        }
    }
    else {
        [self setSearchBarTitleForVenue:nil loading:NO];
        [self setDirectionButtonHidden:YES];
        [self hideContent];
    }
    
    _sceneProperties = sceneProperties;
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

- (void) setSearchBarTitleForVenue:(NSString*) venueName loading:(BOOL) loading {
    if (venueName && venueName.length > 0) {
        if (loading) {
            self.menuBar.searchQueryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Entering in %@...", ""), venueName];
            [self.menuBar showActivityIndicator];
        }
        else {
            self.menuBar.searchQueryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Search in %@...", ""), venueName];
            [self.menuBar hideActivityIndicator];
        }
    }
    else {
        self.menuBar.searchQueryLabel.text = NSLocalizedString(@"Search a venue...", "");
    }
}

- (void) setHidden:(BOOL) hidden {
    [self.menuBar setHidden:hidden];
}


- (void) showContent:(id<MWZObject>) object
            language:(NSString*) language
      showInfoButton:(BOOL) showInfoButton {
    if ([object isKindOfClass:MWZPlace.class]) {
        [self.bottomInfoView selectContentWithPlace:(MWZPlace*)object
                                           language:language
                                     showInfoButton:showInfoButton];
    }
    if ([object isKindOfClass:MWZPlacelist.class]) {
        [self.bottomInfoView selectContentWithPlaceList:(MWZPlacelist*)object
                                               language:language
                                         showInfoButton:showInfoButton];
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

#pragma mark MWZUIBottomInfoViewDelegate
- (void)didPressDirection {
    [_delegate didTapOnDirectionButton];
}

- (void)didPressInformation {
    [_delegate didTapOnInformationButton];
}

@end
