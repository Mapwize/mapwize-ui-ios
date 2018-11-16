#import "MWZComponentDirectionBar.h"
#import "MWZComponentResultList.h"
#import "MWZComponentResultListDelegate.h"
#import "MWZSearchData.h"
#import "MWZComponentDirectionBarDelegate.h"
#import "MWZComponentBorderedTextField.h"
#import "MWZIndoorLocation.h"
#import "MWZComponentLoadingBar.h"
#import "MWZComponentCurrentLocationView.h"

@interface MWZComponentDirectionBar () <UITextFieldDelegate, MWZComponentResultListDelegate>

@end

@implementation MWZComponentDirectionBar {
    
    UIButton* backButton;
    UIButton* swapButton;
    UIButton* accessibilityOn;
    UIButton* accessibilityOff;
    MWZComponentBorderedTextField* fromTextField;
    MWZComponentBorderedTextField* toTextField;
    UIView* backView;
    MWZComponentResultList* resultList;
    MWZComponentLoadingBar* loadingBar;
    MWZComponentCurrentLocationView* currentLocationView;
    
    MWZSearchData* searchData;
    
    UIImage* backImage;
    UIImage* accessibilityOnImage;
    UIImage* accessibilityOffImage;
    UIImage* swapImage;

    NSLayoutConstraint* heightConstraint;
    
    BOOL isInFromSearch;
    BOOL isInToSearch;
    id<MWZDirectionPoint> fromDirectionPoint;
    id<MWZDirectionPoint> toDirectionPoint;
    BOOL isAccessible;
    
    UIColor* color;
    
}

- (instancetype) initWith:(MWZSearchData*) searchData color:(UIColor*) color {
    self = [super init];
    if (self) {
        self->searchData = searchData;
        self->color = color;
        [self setup: color];
    }
    return self;
}
    
- (void) setup:(UIColor*) color {
    self.clipsToBounds = NO;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.cornerRadius = 10;
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMaxYCorner;
    }
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    swapImage = [UIImage imageNamed:@"swap" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOnImage = [UIImage imageNamed:@"accessibilityOn" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOnImage = [accessibilityOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    accessibilityOffImage = [UIImage imageNamed:@"accessibilityOff" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOffImage = [accessibilityOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    accessibilityOff = [[UIButton alloc] init];
    accessibilityOff.translatesAutoresizingMaskIntoConstraints = NO;
    [accessibilityOff setImage:accessibilityOffImage forState:UIControlStateNormal];
    [accessibilityOff.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [accessibilityOff addTarget:self action:@selector(setAccessibilityOff) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessibilityOff];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    
    accessibilityOn = [[UIButton alloc] init];
    accessibilityOn.translatesAutoresizingMaskIntoConstraints = NO;
    [accessibilityOn setImage:accessibilityOnImage forState:UIControlStateNormal];
    [accessibilityOn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [accessibilityOn addTarget:self action:@selector(setAccessibilityOn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessibilityOn];
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:accessibilityOff
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:accessibilityOff
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    swapButton = [[UIButton alloc] init];
    swapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [swapButton addTarget:self action:@selector(swapClick) forControlEvents:UIControlEventTouchUpInside];
    [swapButton setImage:swapImage forState:UIControlStateNormal];
    [self addSubview:swapButton];
    [[NSLayoutConstraint constraintWithItem:swapButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:swapButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:swapButton
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    backButton = [[UIButton alloc] init];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [self addSubview:backButton];
    
    toTextField = [[MWZComponentBorderedTextField alloc] init];
    toTextField.translatesAutoresizingMaskIntoConstraints = NO;
    toTextField.placeholder = NSLocalizedString(@"Destination","");
    toTextField.delegate = self;
    [toTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:toTextField];
    [[NSLayoutConstraint constraintWithItem:toTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toTextField
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:accessibilityOff
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:backButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:backButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:backButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:backButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:toTextField
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    fromTextField = [[MWZComponentBorderedTextField alloc] init];
    fromTextField.translatesAutoresizingMaskIntoConstraints = NO;
    fromTextField.placeholder = NSLocalizedString(@"Starting point","");
    fromTextField.delegate = self;
    [fromTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:fromTextField];
    [[NSLayoutConstraint constraintWithItem:fromTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromTextField
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toTextField
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:swapButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:fromTextField
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:72.0f/2 - 16.0f] setActive:YES];

    heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f];
    [heightConstraint setActive:YES];
    
    [self setAccessibility:NO];
}

- (void) setAccessibility:(BOOL) isAccessible {
    self->isAccessible = isAccessible;
    if (isAccessible) {
        [accessibilityOn setTintColor:color];
        [accessibilityOff setTintColor:[UIColor blackColor]];
    }
    else {
        [accessibilityOff setTintColor:color];
        [accessibilityOn setTintColor:[UIColor blackColor]];
    }
    [self tryToStartDirection];
}
    
- (void) show {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        if (@available(iOS 11.0, *)) {
            self->heightConstraint.constant = self.superview.safeAreaInsets.top + 8.0 + 32 + 8.0 + 32 + 8.0 + 32 + 8.0;
        } else {
            self->heightConstraint.constant = 8.0 + 32 + 8.0 + 32 + 8.0 + 32 + 8.0;
        }
        [self.superview layoutIfNeeded];
    }];
}
    
- (void) hide {
    fromDirectionPoint = nil;
    fromTextField.text = @"";
    toDirectionPoint = nil;
    toTextField.text = @"";
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self->heightConstraint.constant = 0.0f;
        [self.superview layoutIfNeeded];
    }];
}
    
- (void) setAccessibilityOn {
    [self setAccessibility:YES];
}

- (void) setAccessibilityOff {
    [self setAccessibility:NO];
}
    
- (void) swapClick {
    id<MWZDirectionPoint> tmpFrom = fromDirectionPoint;
    id<MWZDirectionPoint> tmpTo = toDirectionPoint;
    [self setFrom:nil];
    [self setTo:nil];
    [self setFrom:tmpTo];
    [self setTo:tmpFrom];
}
    
- (void) backClick {
    if (isInFromSearch) {
        [self setFrom:nil];
        [self closeResultList];
    }
    else if (isInToSearch) {
        [self setTo:nil];
        [self closeResultList];
    }
    else {
        [_mapwizePlugin setDirection:nil];
        [_delegate didStopDirection];
        [_delegate didPressBack];
    }
}
  
- (void) setFrom:(id<MWZDirectionPoint>) fromValue {
    fromDirectionPoint = fromValue;
    if (fromValue == nil) {
        fromTextField.text = @"";
    }
    else if ([fromValue isKindOfClass:MWZPlace.class] || [fromValue isKindOfClass:MWZPlaceList.class]) {
        id<MWZObject> mapwizeObject = (id<MWZObject>) fromValue;
        fromTextField.text = [mapwizeObject titleForLanguage:[_mapwizePlugin getLanguage]];
    }
    else if ([fromValue isKindOfClass:MWZIndoorLocation.class]) {
        fromTextField.text = NSLocalizedString(@"Current location","");
    }
    [self tryToStartDirection];
}
    
- (void) setTo:(id<MWZDirectionPoint>) toValue {
    toDirectionPoint = toValue;
    if (toValue == nil) {
        toTextField.text = @"";
    }
    else if ([toValue isKindOfClass:MWZPlace.class] || [toValue isKindOfClass:MWZPlaceList.class]) {
        id<MWZObject> mapwizeObject = (id<MWZObject>) toValue;
        toTextField.text = [mapwizeObject titleForLanguage:[_mapwizePlugin getLanguage]];
    }
    else if ([toValue isKindOfClass:MWZIndoorLocation.class]) {
        toTextField.text = NSLocalizedString(@"Current location","");
    }
    [self tryToStartDirection];
}
    
- (void) showResultList {
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.alpha = 0.0;
    [self.superview addSubview:backView];
    [self.superview bringSubviewToFront:self];
    [[NSLayoutConstraint constraintWithItem:backView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    NSLayoutConstraint* backViewTopConstraint = [NSLayoutConstraint constraintWithItem:backView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.superview
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0.0f];
    [backViewTopConstraint setActive:YES];
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
    
    UIView* viewToTopConstraint;
    if (_mapwizePlugin.userLocation && _mapwizePlugin.userLocation.floor) {
        currentLocationView = [[MWZComponentCurrentLocationView alloc] init];
        currentLocationView.translatesAutoresizingMaskIntoConstraints = NO;
        viewToTopConstraint = currentLocationView;
        [self addSubview:currentLocationView];
        [[NSLayoutConstraint constraintWithItem:currentLocationView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:backView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:currentLocationView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:backView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:currentLocationView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        
    }
    else {
        viewToTopConstraint = self;
    }
    resultList = [[MWZComponentResultList alloc] init];
    resultList.translatesAutoresizingMaskIntoConstraints = NO;
    resultList.alpha = 0.0f;
    resultList.resultDelegate = self;
    [backView addSubview:resultList];
    [[NSLayoutConstraint constraintWithItem:resultList
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:resultList
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:resultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f - self.superview.safeAreaInsets.bottom];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    } else {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:resultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    }
    NSLayoutConstraint* constraintToHeader = [NSLayoutConstraint constraintWithItem:resultList
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:viewToTopConstraint
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:8.0f];
    NSLayoutConstraint* constraintToBackView = [NSLayoutConstraint constraintWithItem:resultList
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:8.0f];
    constraintToBackView.priority = 800;
    [constraintToHeader setActive:YES];
    [constraintToBackView setActive:YES];
    
    loadingBar = [[MWZComponentLoadingBar alloc] init];
    loadingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:loadingBar];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:2.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:3.0f] setActive:YES];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self->backView.alpha = 1.0f;
        self->resultList.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
}
    
- (void) closeResultList {
    [fromTextField resignFirstResponder];
    [toTextField resignFirstResponder];
    isInToSearch = NO;
    isInFromSearch = NO;
    [UIView animateWithDuration:0.5 animations:^ {
        self->backView.alpha = 0.0f;
        self->resultList.alpha = 0.0f;
        self->currentLocationView.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self->resultList removeFromSuperview];
        [self->backView removeFromSuperview];
        [self->currentLocationView removeFromSuperview];
        self->resultList = nil;
        self->backView = nil;
        self->currentLocationView = nil;
    }];
}
    
- (void) loadEmptyFromSearch {
    [resultList swapResults:searchData.mainFrom];
}
    
- (void) loadEmptyToSearch {
    [resultList swapResults:searchData.mainSearch];
}
    
- (void) searchFrom:(NSString*) query {
    [loadingBar startAnimation];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [_mapwizePlugin getVenue].identifier;
    params.query = query;
    params.objectClass = @[@"place"];
    params.universeId = [_mapwizePlugin getUniverse].identifier;
    [MWZApi searchWithParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->resultList swapResults:searchResponse];
            [self->loadingBar stopAnimation];
        });
    } failure:^(NSError *error) {
        // TODO Should handle this
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->loadingBar stopAnimation];
        });
    }];
}
    
- (void) searchTo:(NSString*) query {
    [loadingBar startAnimation];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [_mapwizePlugin getVenue].identifier;
    params.query = query;
    params.objectClass = @[@"place", @"placeList"];
    params.universeId = [_mapwizePlugin getUniverse].identifier;
    [MWZApi searchWithParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->resultList swapResults:searchResponse];
            [self->loadingBar stopAnimation];
        });
    } failure:^(NSError *error) {
        // TODO Should handle this
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->loadingBar stopAnimation];
        });
    }];
}
    
- (void) tryToStartDirection {
    if (fromDirectionPoint == nil || toDirectionPoint == nil) {
        return;
    }
    [MWZApi getDirectionWithFrom:fromDirectionPoint to:toDirectionPoint isAccessible:isAccessible success:^(MWZDirection *direction) {
        MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
        options.centerOnStart = YES;
        options.displayEndMarker = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapwizePlugin setDirection:direction options:options];
            [self.delegate didStartDirection:direction from:self->fromDirectionPoint to:self->toDirectionPoint];
        });
    } failure:^(NSError *error) {
        // TODO Handle direction error
    }];
}
    
#pragma mark TextFieldDelegate
    
- (void) textFieldDidBeginEditing:(UITextField*) textField {
    if (!resultList) {
        [self showResultList];
    }
    textField.text = @"";
    if (isInFromSearch) {
        fromTextField.text = @"";
    }
    if (isInToSearch) {
        toTextField.text = @"";
    }
    
    if (textField == fromTextField) {
        isInToSearch = NO;
        isInFromSearch = YES;
        [self loadEmptyFromSearch];
    }
    else {
        isInFromSearch = NO;
        isInToSearch = YES;
        [self loadEmptyToSearch];
    }
}
    
- (void) textFieldDidChange:(UITextField*) textField {
    if (!isInFromSearch && !isInToSearch) {
        return;
    }
    if (textField == fromTextField) {
        if ([textField.text isEqualToString:@""]) {
            [self loadEmptyFromSearch];
        }
        else {
            [self searchFrom:textField.text];
        }
    }
    else {
        if ([textField.text isEqualToString:@""]) {
            [self loadEmptyToSearch];
        }
        else {
            [self searchTo:textField.text];
        }
    }
}
    
#pragma mark MWZComponentResultListDelegate

- (void)didSelect:(id<MWZObject>)mapwizeObject {
    if (isInFromSearch) {
        [self setFrom:(id<MWZDirectionPoint>)mapwizeObject];
    }
    if (isInToSearch) {
        [self setTo:(id<MWZDirectionPoint>)mapwizeObject];
    }
    [self closeResultList];
}
    
#pragma mark SafeAreaInsets

- (void) safeAreaInsetsDidChange {
    
}
    
@end
