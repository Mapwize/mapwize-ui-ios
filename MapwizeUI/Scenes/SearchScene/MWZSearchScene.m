#import "MWZSearchScene.h"

@implementation MWZSearchScene

- (instancetype) initWith:(UIColor*) mainColor {
    self = [super init];
    if (self) {
        _mainColor = mainColor;
    }
    return self;
}

- (void)addTo:(UIView *)view {
    self.backgroundView = [[UIView alloc] initWithFrame:view.frame];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.backgroundView];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    
    self.searchQueryBar = [[MWZSearchQueryBar alloc] initWithFrame:CGRectZero];
    self.searchQueryBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchQueryBar.delegate = self;
    [view addSubview:self.searchQueryBar];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right - 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:view.safeAreaInsets.left + 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
    }
    
    self.resultContainerView = [[UIView alloc] init];
    self.resultContainerView.clipsToBounds = YES;
    self.resultContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.resultContainerView];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:view.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        _resultContainerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.resultContainerView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:0.0f];
        _resultContainerViewHeightConstraint.priority = 999;
        [_resultContainerViewHeightConstraint setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        _resultContainerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.resultContainerView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:0.0f];
        _resultContainerViewHeightConstraint.priority = 999;
        [_resultContainerViewHeightConstraint setActive:YES];
    }
    
    self.resultList = [[MWZComponentGroupedResultList alloc] init];
    self.resultList.resultDelegate = self;
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resultContainerView addSubview:self.resultList];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.resultList
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.resultContainerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f
                                                                constant:8.0f];
        top.priority = 998;
        [top setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
    
    } else {
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
    }
}

- (UIView*) getTopViewToConstraint {
    return nil;
}

- (UIView*) getBottomViewToConstraint {
    return nil;
}

- (void)setHidden:(BOOL)hidden { 
    [self.searchQueryBar setHidden:hidden];
    [self.resultList setHidden:hidden];
    [self.resultContainerView setHidden:hidden];
    [self.backgroundView setHidden:hidden];
}

- (void) clearSearch {
    [self.searchQueryBar.searchTextField setText:@""];
    [self showSearchResults:@[]
                  universes:@[]
             activeUniverse:[[MWZUniverse alloc] init]
               withLanguage:@"en"];
}

- (void) showResults:(NSArray<id<MWZObject>> *)results withLanguage:(NSString *)language {
    [self.resultList swapResults:results language:language];
}

- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language {
    [self.resultList swapResults:results
                       universes:universes
                  activeUniverse:activeUniverse
                        language:language];
}

#pragma mark MWZSearchQueryBarDelegate
- (void)searchQueryDidChange:(NSString*) query {
    [_delegate searchQueryDidChange:query];
}

- (void)didTapOnBackButton {
    [_delegate didTapOnBackButton];
}

#pragma mark MWZComponentResultListDelegate
- (void)didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe {
    [_delegate didSelect:mapwizeObject universe:universe];
}

@end
