#import "MWZUIDirectionScene.h"

@interface MWZUIDirectionScene()

@property (nonatomic) NSLayoutConstraint* searchResultBottomConstraint;

@end

@implementation MWZUIDirectionScene

- (instancetype) initWith:(UIColor*) mainColor {
    self = [super init];
    if (self) {
        _mainColor = mainColor;
    }
    return self;
}

- (void) addTo:(UIView*) view {
    self.topConstraintView = [[UIView alloc] init];
    self.topConstraintView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.topConstraintView];
    
    self.topConstraintViewMarginTop = [NSLayoutConstraint constraintWithItem:self.topConstraintView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f
                                                                    constant:0.0f];
    [self.topConstraintViewMarginTop setActive:YES];
    
    self.directionInfo = [[MWZUIDirectionInfo alloc] initWithColor:self.mainColor];
    self.directionInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.directionInfo];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.backgroundView];
    
    self.resultList = [[MWZUIGroupedResultList alloc] init];
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultList.resultDelegate = self;
    [view addSubview:self.resultList];
    
    self.directionHeader = [[MWZUIDirectionHeader alloc] initWithFrame:CGRectZero color:self.mainColor];
    self.directionHeader.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionHeader.delegate = self;
    [view addSubview:self.directionHeader];
    
    self.currentLocationView = [[MWZUICurrentLocationView alloc] init];
    self.currentLocationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentLocationView setHidden:YES];
    UITapGestureRecognizer *currentLocationViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLocationTapped:)];
    currentLocationViewGestureRecognizer.numberOfTapsRequired = 1;
    [self.currentLocationView addGestureRecognizer:currentLocationViewGestureRecognizer];
    [view addSubview:self.currentLocationView];
    
    [[NSLayoutConstraint constraintWithItem:self.currentLocationView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.currentLocationView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.currentLocationView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.directionHeader
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    self.resultListTopConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.directionHeader
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:16.0f];
    
    if (@available(iOS 11.0, *)) {
        _searchResultBottomConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:view.safeAreaLayoutGuide
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:-16.0f];
    }
    else {
        _searchResultBottomConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                         constant:-16.0f];
    }
    
    [_searchResultBottomConstraint setActive:YES];
    
    [self.resultListTopConstraint setActive:YES];
    
    
    [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [self setSearchResultsHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardDidShow: (NSNotification *) notif {
    NSValue* value = notif.userInfo[UIKeyboardFrameEndUserInfoKey];
    double bottom = value.CGRectValue.size.height;
    _searchResultBottomConstraint.constant = -bottom;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    _searchResultBottomConstraint.constant = -16;
}

- (void) currentLocationTapped:(UITapGestureRecognizer*) recognizer {
    [_delegate directionSceneDidTapOnCurrentLocation:self];
}

- (UIView*) getTopViewToConstraint {
    return self.topConstraintView;
}

- (UIView*) getBottomViewToConstraint {
    return self.directionInfo;
}

- (void) setInfoWith:(double) directionTravelTime
   directionDistance:(double) directionDistance
       directionMode:(MWZDirectionMode*) directionMode {
    [self.directionInfo setInfoWith:directionTravelTime directionDistance:directionDistance];
}

- (void) openFromSearch {
    [self.directionHeader openFromSearch];
}

- (void) closeFromSearch {
    [self.directionHeader closeFromSearch];
}

- (void) openToSearch {
    [self.directionHeader openToSearch];
}

- (void) closeToSearch {
    [self.directionHeader closeToSearch];
}

- (void) showLoading {
    [self.directionInfo showLoading];
}
- (void) hideLoading {
    [self.directionInfo hideLoading];
}

- (void) showErrorMessage:(NSString*) errorMessage {
    [self.directionInfo showErrorMessage:errorMessage];
}

- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language
                  forQuery:(NSString*) query {
    [self.resultList swapResults:results
                       universes:universes
                  activeUniverse:activeUniverse
                        language:language
                        forQuery:query];
}

- (void) setDirectionInfoHidden:(BOOL) hidden {
    if (hidden) {
        [self.directionInfo close];
        /*[UIView animateWithDuration:0.5 animations:^{
            [self.directionInfo setTransform:CGAffineTransformMakeTranslation(0,self.directionInfo.frame.size.height)];
        } completion:^(BOOL finished) {
            [self.directionInfo setHidden:YES];
        }];*/
    }
    else {
        if ([self.directionInfo isHidden]) {
            [self.directionInfo setTransform:CGAffineTransformMakeTranslation(0,self.directionInfo.frame.size.height)];
            [self.directionInfo setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                [self.directionInfo setTransform:CGAffineTransformMakeTranslation(0,0)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void) setSearchResultsHidden:(BOOL) hidden {
    [self.directionHeader setButtonsHidden:!hidden];
    //self.currentLocationView.alpha = 0.0;
    if (hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.backgroundView setTransform:CGAffineTransformMakeTranslation(0,self.backgroundView.superview.frame.size.height)];
            [self.resultList setTransform:CGAffineTransformMakeTranslation(0,self.backgroundView.superview.frame.size.height)];
            [self.currentLocationView setTransform:CGAffineTransformMakeTranslation(0,self.backgroundView.superview.frame.size.height)];
        } completion:^(BOOL finished) {
            [self.backgroundView setHidden:hidden];
            [self.resultList setHidden:hidden];
        }];
    }
    else {
        [self.backgroundView setHidden:hidden];
        [self.resultList setHidden:hidden];
        [UIView animateWithDuration:0.5 animations:^{
            [self.backgroundView setTransform:CGAffineTransformMakeTranslation(0,0)];
            [self.resultList setTransform:CGAffineTransformMakeTranslation(0,0)];
            [self.currentLocationView setTransform:CGAffineTransformMakeTranslation(0,0)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                //self.currentLocationView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void) setCurrentLocationViewHidden:(BOOL) hidden {
    [self.resultListTopConstraint setActive:NO];
    if (hidden) {
        self.resultListTopConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.directionHeader
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:16.0f];
    }
    else {
        self.resultListTopConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.currentLocationView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:16.0f];
    }
    [self.resultListTopConstraint setActive:YES];
    [self.currentLocationView setHidden:hidden];
}

- (void) setHidden:(BOOL) hidden {
    [self.directionHeader setHidden:hidden];
    [self.backgroundView setHidden:hidden];
    [self.resultList setHidden:hidden];
}

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.directionHeader setFromText:text asPlaceHolder:asPlaceHolder];
}

-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.directionHeader setToText:text asPlaceHolder:asPlaceHolder];
}

- (void) setAvailableModes:(NSArray<MWZDirectionMode*>*) modes {
    [self.directionHeader setAvailableModes:modes];
}

- (void) setSelectedMode:(MWZDirectionMode*) mode {
    [self.directionHeader setSelectedMode:mode];
}

- (void)directionHeaderDidTapOnBackButton:(MWZUIDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnBackButton:self];
}

- (void)directionHeaderDidTapOnFromButton:(MWZUIDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnFromButton:self];
}

- (void)directionHeaderDidTapOnToButton:(MWZUIDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnToButton:self];
}

- (void)directionHeaderDidTapOnSwapButton:(MWZUIDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnSwapButton:self];
}

- (void) directionHeaderDirectionModeDidChange:(MWZDirectionMode*) directionMode {
    [_delegate directionSceneDirectionModeDidChange:directionMode];
}

- (void) searchDirectionQueryDidChange:(NSString*) query {
    [_delegate searchDirectionQueryDidChange:query];
}

- (void)didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe forQuery:(NSString*) query {
    [_delegate didSelect:mapwizeObject universe:universe forQuery:query];
}

@end
