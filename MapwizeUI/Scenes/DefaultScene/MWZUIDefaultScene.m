#import "MWZUIDefaultScene.h"
#import "MWZUIBottomSheetDelegate.h"
#import "MWZUIBottomSheetComponents.h"

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
    
    _bottomSheet = [[MWZUIBottomSheet alloc] initWithFrame:view.frame color:_mainColor];
    _bottomSheet.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:_bottomSheet];
    [[_bottomSheet.leadingAnchor constraintEqualToAnchor:view.leadingAnchor] setActive:YES];
    [[_bottomSheet.trailingAnchor constraintEqualToAnchor:view.trailingAnchor] setActive:YES];
    _bottomSheet.delegate = self;
}

- (UIView*) getTopViewToConstraint {
    return self.menuBar;
}

- (UIView*) getBottomViewToConstraint {
    return self.bottomSheet;
}

- (void) setSceneProperties:(MWZUIDefaultSceneProperties *)sceneProperties {
    
    if (sceneProperties.venue) {
        [self setSearchBarTitleForVenue:[sceneProperties.venue titleForLanguage:sceneProperties.language] loading:sceneProperties.venueLoading];
        if (!_sceneProperties.venue) {
            [self setDirectionButtonHidden:NO];
        }
        else if ([sceneProperties.selectedContent isKindOfClass:MWZPlacePreview.class]) {
            [self showContent:sceneProperties.selectedContent language:sceneProperties.language showInfoButton:NO];
        }
        else if (sceneProperties.selectedContent && sceneProperties.placeDetails) {
            [self showContent:sceneProperties.placeDetails
                     language:sceneProperties.language
               showInfoButton:!sceneProperties.infoButtonHidden];
        }
        else if ([sceneProperties.selectedContent isKindOfClass:MWZPlacelist.class]) {
            [self showContent:sceneProperties.selectedContent language:sceneProperties.language showInfoButton:NO];
        }
        else if ([sceneProperties.selectedContent isKindOfClass:MWZPlace.class]) {
            [self showContent:sceneProperties.selectedContent language:sceneProperties.language showInfoButton:NO];
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


- (void) showContent:(id) object
            language:(NSString*) language
      showInfoButton:(BOOL) showInfoButton {
    if ([object isKindOfClass:MWZPlacePreview.class]) {
        [self.bottomSheet showPlacePreview:object];
    }
    if ([object isKindOfClass:MWZPlaceDetails.class]) {
        [self.bottomSheet showPlaceDetails:object shouldShowInformationButton:showInfoButton language:language];
    }
    if ([object isKindOfClass:MWZPlacelist.class]) {
        [self.bottomSheet showPlacelist:object shouldShowInformationButton:showInfoButton language:language];
    }
    if ([object isKindOfClass:MWZPlace.class]) {
        [self.bottomSheet showPlace:object shouldShowInformationButton:showInfoButton language:language];
    }
}

- (void) hideContent {
    [self.bottomSheet removeContent];
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

- (MWZUIBottomSheetComponents *)requireComponentForPlaceDetails:(MWZPlace *)place
                                   withDefaultComponents:(MWZUIBottomSheetComponents *)components {
    if (_delegate && [_delegate respondsToSelector:@selector(requireComponentForPlaceDetails:withDefaultComponents:)]) {
        return [_delegate requireComponentForPlaceDetails:place withDefaultComponents:components];
    }
    return components;
}

- (MWZUIBottomSheetComponents *)requireComponentForPlacelist:(MWZPlacelist *)placelist withDefaultComponents:(MWZUIBottomSheetComponents *)components {
    if (_delegate && [_delegate respondsToSelector:@selector(requireComponentForPlacelist:withDefaultComponents:)]) {
        return [_delegate requireComponentForPlacelist:placelist withDefaultComponents:components];
    }
    return components;
}

- (void) didClose {
    if (_delegate && [_delegate respondsToSelector:@selector(didClose)]) {
        [_delegate didClose];
    }
}

- (void) didTapOnCallButton {
    [_delegate didTapOnCallButton];
}

- (void) didTapOnShareButton {
    [_delegate didTapOnShareButton];
}

- (void) didTapOnWebsiteButton {
    [_delegate didTapOnWebsiteButton];
}

- (void) didTapOnInfoButton {
    [_delegate didTapOnInformationButton];
}




@end
