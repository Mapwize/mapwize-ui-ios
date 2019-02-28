#import "MWZComponentSearchBar.h"
#import "MWZComponentGroupedResultList.h"
#import "MWZComponentResultList.h"
#import "MWZComponentResultListDelegate.h"
#import "MWZComponentGroupedResultListDelegate.h"
#import "MWZSearchData.h"
#import "MWZComponentSearchBarDelegate.h"
#import "MWZComponentLoadingBar.h"
#import "MWZMapwizeViewUISettings.h"
@interface MWZComponentSearchBar () <UITextFieldDelegate, MWZComponentResultListDelegate, MWZComponentGroupedResultListDelegate>

@end

@implementation MWZComponentSearchBar {
    UIButton* menuButton;
    UIButton* directionButton;
    UITextField* searchTextField;
    UIView* backView;
    MWZComponentGroupedResultList* resultList;
    MWZComponentResultList* venueResultList;
    UITableView* activeResultList;
    MWZSearchData* searchData;
    
    BOOL isInSearch;
    NSLayoutConstraint* backViewTopConstaint;
    
    NSLayoutConstraint* menuButtonWidth;
    UIImage* menuImage;
    UIImage* backImage;
    UIImage* directionImage;
    
    BOOL menuIsHidden;
}

- (instancetype) initWith:(MWZSearchData*) searchData uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super init];
    if (self) {
        self->searchData = searchData;
        self->menuIsHidden = uiSettings.menuButtonIsHidden;
        [self setup];
    }
    return self;
}

- (void) setup {
    isInSearch = NO;
    self.clipsToBounds = NO;
    self.layer.cornerRadius = 10;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    if (!menuIsHidden) {
        menuImage = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else {
        menuImage = [UIImage imageNamed:@"" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    directionImage = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    menuButton = [[UIButton alloc] init];
    menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:menuButton];
    [[NSLayoutConstraint constraintWithItem:menuButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:menuButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:menuButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:menuButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    menuButton.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    
    menuButtonWidth = [NSLayoutConstraint constraintWithItem:menuButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f];
    
    if (menuIsHidden) {
        menuButtonWidth.constant = 0.0f;
    }
    [menuButtonWidth setActive:YES];
    
    directionButton = [[UIButton alloc] init];
    directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [directionButton setImage:directionImage forState:UIControlStateNormal];
    [directionButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    directionButton.contentEdgeInsets = UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f);
    directionButton.alpha = 0.0f;
    [directionButton addTarget:self action:@selector(directionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:directionButton];
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    searchTextField = [[UITextField alloc] init];
    searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    searchTextField.placeholder = NSLocalizedString(@"Search a venue...", "");
    searchTextField.delegate = self;
    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:searchTextField];
    [[NSLayoutConstraint constraintWithItem:searchTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:directionButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:searchTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:searchTextField
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:searchTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:menuButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
}

- (void) showResultList {
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.alpha = 0.0f;
    [self.superview addSubview:backView];
    [self.superview bringSubviewToFront:self];
    [[NSLayoutConstraint constraintWithItem:backView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    backViewTopConstaint = [NSLayoutConstraint constraintWithItem:backView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f];
    [backViewTopConstaint setActive:YES];
    [[NSLayoutConstraint constraintWithItem:backView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:backView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    if ([_mapwizePlugin getVenue]) {
        resultList = [[MWZComponentGroupedResultList alloc] init];
        resultList.resultDelegate = self;
        [resultList setLanguage:[_mapwizePlugin getLanguage]];
        activeResultList = resultList;
    }
    else {
        venueResultList = [[MWZComponentResultList alloc] init];
        venueResultList.resultDelegate = self;
        [venueResultList setLanguage:[_mapwizePlugin getLanguage]];
        activeResultList = venueResultList;
    }
    
    activeResultList.translatesAutoresizingMaskIntoConstraints = NO;
    activeResultList.alpha = 0.0f;
    [backView addSubview:activeResultList];
    [[NSLayoutConstraint constraintWithItem:activeResultList
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:activeResultList
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:activeResultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f - self.superview.safeAreaInsets.bottom];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    } else {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:activeResultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    }
    NSLayoutConstraint* constraintToSearch = [NSLayoutConstraint constraintWithItem:activeResultList
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:8.0f];
    NSLayoutConstraint* constraintToBackView = [NSLayoutConstraint constraintWithItem:activeResultList
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:backView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f
                                                                           constant:8.0f];
    constraintToBackView.priority = 800;
    [constraintToSearch setActive:YES];
    [constraintToBackView setActive:YES];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self->backView.alpha = 1.0f;
        self->activeResultList.alpha = 1.0f;
        self->directionButton.alpha = 0.0;
        if (self->menuIsHidden) {
            self->menuButtonWidth.constant = 32.0f;
        }
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self->directionButton setEnabled:NO];
        if (self->menuIsHidden) {
            [UIView transitionWithView:self->menuButton duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self->menuButton setImage:self->backImage forState:UIControlStateNormal];
                            } completion:nil];
        }
    }];
    
    if (!self->menuIsHidden) {
        [UIView transitionWithView:self->menuButton duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self->menuButton setImage:self->backImage forState:UIControlStateNormal];
                        } completion:nil];
    }
    
}

- (void) closeResultList {
    isInSearch = NO;
    [searchTextField resignFirstResponder];
    [searchTextField setText:@""];
    [self->directionButton setEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^ {
        self->backView.alpha = 0.0f;
        self->activeResultList.alpha = 0.0f;
        self->directionButton.alpha = 1.0f;
        if (self->menuIsHidden) {
            self->menuButtonWidth.constant = 0.0f;
            [self->menuButton setImage:self->menuImage forState:UIControlStateNormal];
        }
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self->activeResultList removeFromSuperview];
        [self->backView removeFromSuperview];
        self->resultList = nil;
        self->venueResultList = nil;
        self->backView = nil;
    }];
    
    if (!menuIsHidden) {
        [UIView transitionWithView:self->menuButton duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self->menuButton setImage:self->menuImage forState:UIControlStateNormal];
                        } completion:nil];
    }
}

- (void) loadEmptySearch {
    if ([_mapwizePlugin getVenue]) {
        [resultList swapResults:searchData.mainSearch universes:searchData.accessibleUniverses activeUniverse:[_mapwizePlugin getUniverse]];
    }
    else {
        [venueResultList swapResults:searchData.venues];
    }
}

- (void) search:(NSString*) query {
    [_delegate didStartLoading];
    if ([_mapwizePlugin getVenue]) {
        MWZSearchParams* params = [[MWZSearchParams alloc] init];
        params.venueId = [_mapwizePlugin getVenue].identifier;
        params.query = query;
        params.objectClass = @[@"place", @"placeList"];
        [MWZApi searchWithParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->resultList swapResults:searchResponse universes:self->searchData.accessibleUniverses activeUniverse:[self.mapwizePlugin getUniverse]];
                [_delegate didStopLoading];
            });
        } failure:^(NSError *error) {
            // TODO Should handle this
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate didStopLoading];
            });
        }];
    }
    else {
        MWZSearchParams* params = [[MWZSearchParams alloc] init];
        params.venueId = [_mapwizePlugin getVenue].identifier;
        params.query = query;
        params.objectClass = @[@"venue"];
        [MWZApi searchWithParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->venueResultList swapResults:searchResponse];
                [_delegate didStopLoading];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate didStopLoading];
            });
        }];
    }
}

- (void) menuClick {
    if (isInSearch) {
        [self closeResultList];
    }
    else {
        [_delegate didPressMenu];
    }
}

- (void) directionClick {
    [_delegate didPressDirection];
}

#pragma mark MapwizePluginBehaviour

- (void) mapwizeWillEnterInVenue:(MWZVenue*) venue {
    searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Entering in %@...", ""), [venue titleForLanguage:[_mapwizePlugin getLanguage]]];
    [searchTextField setEnabled:NO];
    [menuButton setEnabled:NO];
    [directionButton setEnabled:NO];
}

- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue {
    searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Search in %@...", ""), [venue titleForLanguage:[_mapwizePlugin getLanguage]]];
    [searchTextField setEnabled:YES];
    [menuButton setEnabled:YES];
    [directionButton setEnabled:YES];
    [directionButton setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^ {
        self->directionButton.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
}

- (void) mapwizeDidExitVenue:(MWZVenue*) venue {
    searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Search a venue...", "")];
    [UIView animateWithDuration:0.5 animations:^ {
        self->directionButton.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self->directionButton setHidden:YES];
    }];
}

#pragma mark TextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    isInSearch = YES;
    [self showResultList];
    textField.text = @"";
    [self loadEmptySearch];
}

- (void) textFieldDidChange:(UITextField*) textField {
    if (!isInSearch) {
        return;
    }
    if ([textField.text isEqualToString:@""]) {
        [self loadEmptySearch];
    }
    else {
        [self search:textField.text];
    }
}

#pragma mark MWZComponentResultListDelegate

- (void) didSelect:(id<MWZObject>)mapwizeObject {
    [self closeResultList];
    if (!_delegate) {
        return;
    }
    if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
        MWZVenue* venue = (MWZVenue*) mapwizeObject;
        [_delegate didSelectVenue:venue];
    }
}

#pragma mark MWZComponentGroupedResultListDelegate

- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe {
    [self closeResultList];
    if (!_delegate) {
        return;
    }
    if ([mapwizeObject isKindOfClass:MWZPlaceList.class]) {
        MWZPlaceList* placelist = (MWZPlaceList*) mapwizeObject;
        [_delegate didSelectPlaceList:placelist universe:universe];
    }
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        MWZPlace* place = (MWZPlace*) mapwizeObject;
        [_delegate didSelectPlace:place universe:universe];
    }
}


@end
