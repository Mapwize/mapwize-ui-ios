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

- (void) setHidden:(BOOL) hidden {
    [self.menuBar setHidden:hidden];
}

- (void) showContentWithPlace:(MWZPlace*) place language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
    [self.bottomInfoView selectContentWithPlace:place language:language showInfoButton:showInfoButton];
}

- (void) showContentWithPlaceList:(MWZPlacelist*) placeList language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
    [self.bottomInfoView selectContentWithPlaceList:placeList language:language showInfoButton:showInfoButton];
}

- (void) hideContent {
    
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
