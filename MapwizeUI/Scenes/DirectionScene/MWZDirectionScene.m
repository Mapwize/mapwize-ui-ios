#import "MWZDirectionScene.h"

@implementation MWZDirectionScene

- (void) addTo:(UIView*) view {
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.backgroundView];
    
    self.resultList = [[MWZComponentResultList alloc] init];
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultList.resultDelegate = self;
    [view addSubview:self.resultList];
    
    self.directionHeader = [[MWZDirectionHeader alloc] initWithFrame:CGRectZero];
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
    /*[[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];*/
    
    [self setSearchResultsHidden:YES];
    
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

- (void) showSearchResults:(NSArray<id<MWZObject>>*) results withLanguage:(NSString*) language {
    [self.resultList swapResults:results withLanguage:language];
}

- (void) setSearchResultsHidden:(BOOL) hidden {
    [self.directionHeader setSwapButtonHidden:!hidden];
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

- (void)didSelect:(id<MWZObject>)mapwizeObject {
    [_delegate didSelect:mapwizeObject];
}

@end
