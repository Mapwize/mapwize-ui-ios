#import "MWZDirectionScene.h"

@implementation MWZDirectionScene

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
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.backgroundView];
    
    self.resultList = [[MWZComponentGroupedResultList alloc] init];
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultList.resultDelegate = self;
    [view addSubview:self.resultList];
    
    self.directionHeader = [[MWZDirectionHeader alloc] initWithFrame:CGRectZero color:self.mainColor];
    self.directionHeader.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionHeader.delegate = self;
    [view addSubview:self.directionHeader];
    
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
    [[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.directionHeader
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    self.directionInfo = [[MWZComponentDirectionInfo alloc] initWithColor:self.mainColor];
    self.directionInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.directionInfo];
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
    
}

- (UIView*) getTopViewToConstraint {
    return self.topConstraintView;
}

- (UIView*) getBottomViewToConstraint {
    return self.directionInfo;
}

- (void) setInfoWith:(double) directionTravelTime
   directionDistance:(double) directionDistance
        isAccessible:(BOOL) isAccessible {
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

- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language {
    [self.resultList swapResults:results
                       universes:universes
                  activeUniverse:activeUniverse
                        language:language];
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
    if (hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.backgroundView setTransform:CGAffineTransformMakeTranslation(0,self.backgroundView.superview.frame.size.height)];
            [self.resultList setTransform:CGAffineTransformMakeTranslation(0,self.backgroundView.superview.frame.size.height)];
        } completion:^(BOOL finished) {
            //[self.backgroundView setHidden:hidden];
            //[self.resultList setHidden:hidden];
        }];
    }
    else {
        [self.backgroundView setHidden:hidden];
        [self.resultList setHidden:hidden];
        [UIView animateWithDuration:0.5 animations:^{
            [self.backgroundView setTransform:CGAffineTransformMakeTranslation(0,0)];
            [self.resultList setTransform:CGAffineTransformMakeTranslation(0,0)];
        } completion:^(BOOL finished) {
            
        }];
    }
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

-(void) setAccessibleMode:(BOOL) isAccessible {
    [self.directionHeader setAccessibleMode:isAccessible];
}

- (void)directionHeaderDidTapOnBackButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnBackButton:self];
}

- (void)directionHeaderDidTapOnFromButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnFromButton:self];
}

- (void)directionHeaderDidTapOnToButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnToButton:self];
}

- (void)directionHeaderDidTapOnSwapButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnSwapButton:self];
}

- (void) directionHeaderAccessibilityModeDidChange:(BOOL) isAccessible {
    [_delegate directionSceneAccessibilityModeDidChange:isAccessible];
}

- (void) searchDirectionQueryDidChange:(NSString*) query {
    [_delegate searchDirectionQueryDidChange:query];
}

- (void)didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe {
    [_delegate didSelect:mapwizeObject universe:universe];
}

@end
