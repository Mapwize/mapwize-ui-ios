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

@property (nonatomic, weak) id<MWZMapwizeApi> mapwizeApi;
@property (nonatomic) UIButton* menuButton;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UITextField* searchTextField;
@property (nonatomic) UIView* backView;
@property (nonatomic) MWZComponentGroupedResultList* resultList;
@property (nonatomic) MWZComponentResultList* venueResultList;
@property (nonatomic) UITableView* activeResultList;
@property (nonatomic, weak) MWZSearchData* searchData;
@property (nonatomic) BOOL isInSearch;
@property (nonatomic) BOOL menuIsHidden;
@property (nonatomic) NSLayoutConstraint* backViewTopConstaint;
@property (nonatomic) NSLayoutConstraint* menuButtonWidth;
@property (nonatomic) UIImage* menuImage;
@property (nonatomic) UIImage* backImage;
@property (nonatomic) UIImage* directionImage;

@end

@implementation MWZComponentSearchBar

- (instancetype) initWith:(MWZSearchData*) searchData
               uiSettings:(MWZMapwizeViewUISettings*) uiSettings
               mapwizeApi:(id<MWZMapwizeApi>) mapwizeApi {
    self = [super init];
    if (self) {
        _searchData = searchData;
        _menuIsHidden = uiSettings.menuButtonIsHidden;
        _mapwizeApi = mapwizeApi;
        [self setup];
    }
    return self;
}

- (void) setup {
    self.isInSearch = NO;
    self.clipsToBounds = NO;
    self.layer.cornerRadius = 10;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    if (!self.menuIsHidden) {
        self.menuImage = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else {
        self.menuImage = [UIImage imageNamed:@"" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    self.backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    self.directionImage = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    self.menuButton = [[UIButton alloc] init];
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.menuButton setImage:self.menuImage forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.menuButton];
    [[NSLayoutConstraint constraintWithItem:self.menuButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.menuButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.menuButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.menuButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    self.menuButton.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    
    self.menuButtonWidth = [NSLayoutConstraint constraintWithItem:self.menuButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:32.f];
    
    if (self.menuIsHidden) {
        self.menuButtonWidth.constant = 0.0f;
    }
    [self.menuButtonWidth setActive:YES];
    
    self.directionButton = [[UIButton alloc] init];
    self.directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.directionButton setImage:self.directionImage forState:UIControlStateNormal];
    [self.directionButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.directionButton.contentEdgeInsets = UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f);
    self.directionButton.alpha = 0.0f;
    [self.directionButton addTarget:self action:@selector(directionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.directionButton];
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextField.placeholder = NSLocalizedString(@"Search a venue...", "");
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.searchTextField];
    [[NSLayoutConstraint constraintWithItem:self.searchTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.directionButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchTextField
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.menuButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
}

- (void) showResultList {
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backView.alpha = 0.0f;
    [self.superview addSubview:self.backView];
    [self.superview bringSubviewToFront:self];
    [[NSLayoutConstraint constraintWithItem:self.backView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    self.backViewTopConstaint = [NSLayoutConstraint constraintWithItem:self.backView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f
                                                              constant:0.0f];
    [self.backViewTopConstaint setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    if ([self.delegate componentRequiresCurrentVenue:self]) {
        self.resultList = [[MWZComponentGroupedResultList alloc] init];
        self.resultList.resultDelegate = self;
        [self.resultList setLanguage:[self.delegate componentRequiresCurrentLanguage:self]];
        self.activeResultList = self.resultList;
    }
    else {
        self.venueResultList = [[MWZComponentResultList alloc] init];
        self.venueResultList.resultDelegate = self;
        [self.venueResultList setLanguage:[self.delegate componentRequiresCurrentLanguage:self]];
        self.activeResultList = self.venueResultList;
    }
    
    self.activeResultList.translatesAutoresizingMaskIntoConstraints = NO;
    self.activeResultList.alpha = 0.0f;
    [self.backView addSubview:self.activeResultList];
    [[NSLayoutConstraint constraintWithItem:self.activeResultList
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.activeResultList
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.activeResultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:self.backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f - self.superview.safeAreaInsets.bottom];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    } else {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.activeResultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:self.backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    }
    NSLayoutConstraint* constraintToSearch = [NSLayoutConstraint constraintWithItem:self.activeResultList
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:8.0f];
    NSLayoutConstraint* constraintToBackView = [NSLayoutConstraint constraintWithItem:self.activeResultList
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.backView
                                                                            attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0f
                                                                             constant:8.0f];
    constraintToBackView.priority = 800;
    [constraintToSearch setActive:YES];
    [constraintToBackView setActive:YES];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 1.0f;
        self.activeResultList.alpha = 1.0f;
        self.directionButton.alpha = 0.0;
        if (self.menuIsHidden) {
            self.menuButtonWidth.constant = 32.0f;
        }
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.directionButton setEnabled:NO];
        if (self.menuIsHidden) {
            [UIView transitionWithView:self.menuButton duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.menuButton setImage:self.backImage forState:UIControlStateNormal];
                            } completion:nil];
        }
    }];
    
    if (!self.menuIsHidden) {
        [UIView transitionWithView:self.menuButton duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.menuButton setImage:self.backImage forState:UIControlStateNormal];
                        } completion:nil];
    }
    
}

- (void) closeResultList {
    self.isInSearch = NO;
    [self.searchTextField resignFirstResponder];
    [self.searchTextField setText:@""];
    [self.directionButton setEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^ {
        self.backView.alpha = 0.0f;
        self.activeResultList.alpha = 0.0f;
        self.directionButton.alpha = 1.0f;
        if (self.menuIsHidden) {
            self.menuButtonWidth.constant = 0.0f;
            [self.menuButton setImage:self.menuImage forState:UIControlStateNormal];
        }
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.activeResultList removeFromSuperview];
        [self.backView removeFromSuperview];
        self.resultList = nil;
        self.venueResultList = nil;
        self.backView = nil;
    }];
    
    if (!self.menuIsHidden) {
        [UIView transitionWithView:self.menuButton duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.menuButton setImage:self.menuImage forState:UIControlStateNormal];
                        } completion:nil];
    }
}

- (void) loadEmptySearch {
    if ([self.delegate componentRequiresCurrentVenue:self]) {
        [self.resultList swapResults:self.searchData.mainSearch universes:self.searchData.accessibleUniverses activeUniverse:[self.delegate componentRequiresCurrentUniverse:self]];
    }
    else {
        [self.venueResultList swapResults:self.searchData.venues];
    }
}

- (void) search:(NSString*) query {
    [self.delegate didStartLoading];
    MWZVenue* venue = [self.delegate componentRequiresCurrentVenue:self];
    if (venue) {
        MWZSearchParams* params = [[MWZSearchParams alloc] init];
        params.venueId = venue.identifier;
        params.query = query;
        params.objectClass = @[@"place", @"placeList"];
        [self.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultList swapResults:searchResponse universes:self.searchData.accessibleUniverses activeUniverse:[self.delegate componentRequiresCurrentUniverse:self]];
                [self.delegate didStopLoading];
            });
        } failure:^(NSError *error) {
            // TODO Should handle this
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didStopLoading];
            });
        }];
    }
    else {
        MWZSearchParams* params = [[MWZSearchParams alloc] init];
        params.query = query;
        params.objectClass = @[@"venue"];
        [self.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.venueResultList swapResults:searchResponse];
                [self.delegate didStopLoading];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didStopLoading];
            });
        }];
    }
}

- (void) menuClick {
    if (self.isInSearch) {
        [self closeResultList];
    }
    else {
        [self.delegate didPressMenu];
    }
}

- (void) directionClick {
    [self.delegate didPressDirection];
}

#pragma mark MapwizePluginBehaviour

- (void) mapwizeWillEnterInVenue:(MWZVenue*) venue {
    self.searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Entering in %@...", ""), [venue titleForLanguage:[self.delegate componentRequiresCurrentLanguage:self]]];
    [self.searchTextField setEnabled:NO];
    [self.menuButton setEnabled:NO];
    [self.directionButton setEnabled:NO];
}

- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue {
    self.searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Search in %@...", ""), [venue titleForLanguage:[self.delegate componentRequiresCurrentLanguage:self]]];
    [self.searchTextField setEnabled:YES];
    [self.menuButton setEnabled:YES];
    [self.directionButton setEnabled:YES];
    [self.directionButton setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^ {
        self.directionButton.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
}

- (void) mapwizeDidExitVenue:(MWZVenue*) venue {
    self.searchTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Search a venue...", "")];
    [UIView animateWithDuration:0.5 animations:^ {
        self.directionButton.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        //[self.directionButton setEnabled:NO];
    }];
}

#pragma mark TextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.isInSearch = YES;
    [self showResultList];
    textField.text = @"";
    [self loadEmptySearch];
}

- (void) textFieldDidChange:(UITextField*) textField {
    if (!self.isInSearch) {
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
    if (!self.delegate) {
        return;
    }
    if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
        MWZVenue* venue = (MWZVenue*) mapwizeObject;
        [self.delegate didSelectVenue:venue];
    }
}

#pragma mark MWZComponentGroupedResultListDelegate

- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe {
    [self closeResultList];
    if (!self.delegate) {
        return;
    }
    if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
        MWZPlacelist* placelist = (MWZPlacelist*) mapwizeObject;
        [self.delegate didSelectPlaceList:placelist universe:universe];
    }
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        MWZPlace* place = (MWZPlace*) mapwizeObject;
        [self.delegate didSelectPlace:place universe:universe];
    }
}


@end
