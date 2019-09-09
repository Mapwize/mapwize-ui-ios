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
    MWZComponentCurrentLocationView* currentLocationView;
    
    MWZSearchData* searchData;
    
    UIImageView* fromPictoImageView;
    UIImageView* toPictoImageView;
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
    UIColor* haloColor;
    
    id<MWZMapwizeApi> mapwizeApi;
}

- (instancetype) initWithMapwizeApi:(id<MWZMapwizeApi>) mapwizeApi
                         searchData:(MWZSearchData*) searchData
                              color:(UIColor*) color {
    self = [super init];
    if (self) {
        self->searchData = searchData;
        self->color = color;
        self->mapwizeApi = mapwizeApi;
        [self addViews];
        [self setupConstraints];
    }
    return self;
}

- (void) addViews {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    swapImage = [UIImage imageNamed:@"swap" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOnImage = [UIImage imageNamed:@"accessibilityOn" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOnImage = [accessibilityOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    accessibilityOffImage = [UIImage imageNamed:@"accessibilityOff" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOffImage = [accessibilityOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    fromPictoImageView = [[UIImageView alloc] init];
    fromPictoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [fromPictoImageView setImage:[UIImage imageNamed:@"followOff" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self addSubview:fromPictoImageView];
    
    toPictoImageView = [[UIImageView alloc] init];
    toPictoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [toPictoImageView setImage:[UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self addSubview:toPictoImageView];
    
    accessibilityOff = [[UIButton alloc] init];
    accessibilityOff.translatesAutoresizingMaskIntoConstraints = NO;
    [accessibilityOff setImage:accessibilityOffImage forState:UIControlStateNormal];
    [accessibilityOff.imageView setContentMode:UIViewContentModeScaleAspectFit];
    CGFloat redComponent = CGColorGetComponents(color.CGColor)[0];
    CGFloat greenComponent = CGColorGetComponents(color.CGColor)[1];
    CGFloat blueComponent = CGColorGetComponents(color.CGColor)[2];
    haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
    accessibilityOff.backgroundColor = haloColor;
    accessibilityOff.layer.cornerRadius = 16.0;
    accessibilityOff.layer.masksToBounds = YES;
    accessibilityOff.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
    [accessibilityOff addTarget:self action:@selector(setAccessibilityOff) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessibilityOff];
    
    accessibilityOn = [[UIButton alloc] init];
    accessibilityOn.translatesAutoresizingMaskIntoConstraints = NO;
    [accessibilityOn setImage:accessibilityOnImage forState:UIControlStateNormal];
    [accessibilityOn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    accessibilityOn.layer.cornerRadius = 16.0;
    accessibilityOn.layer.masksToBounds = YES;
    accessibilityOn.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
    [accessibilityOn addTarget:self action:@selector(setAccessibilityOn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accessibilityOn];
    
    swapButton = [[UIButton alloc] init];
    swapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [swapButton addTarget:self action:@selector(swapClick) forControlEvents:UIControlEventTouchUpInside];
    [swapButton setImage:swapImage forState:UIControlStateNormal];
    [self addSubview:swapButton];
    
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
    
    fromTextField = [[MWZComponentBorderedTextField alloc] init];
    fromTextField.translatesAutoresizingMaskIntoConstraints = NO;
    fromTextField.placeholder = NSLocalizedString(@"Starting point","");
    fromTextField.delegate = self;
    [fromTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:fromTextField];
}

- (void) setupConstraints {
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
    
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:toTextField
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:0.66f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOff
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:72.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:accessibilityOn
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:fromTextField
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.33f
                                   constant:0.f] setActive:YES];
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
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:72.0f] setActive:YES];
    
    
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
    
    [[NSLayoutConstraint constraintWithItem:fromPictoImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromPictoImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromPictoImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:fromPictoImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:backButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:fromTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
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
                                     toItem:fromPictoImageView
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
    
    [[NSLayoutConstraint constraintWithItem:toPictoImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toPictoImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toPictoImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:toPictoImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:toTextField
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:toTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
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
                                     toItem:toPictoImageView
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
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:fromTextField
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:swapButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:fromTextField
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:88.0f/2 - 16.0f] setActive:YES];

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
        accessibilityOff.backgroundColor = [UIColor colorWithRed:197.f/255.f green:21.f/255.f blue:134.f/255.f alpha:0.0f];
        accessibilityOn.backgroundColor = haloColor;
    }
    else {
        accessibilityOff.backgroundColor = haloColor;
        accessibilityOn.backgroundColor = [UIColor colorWithRed:197.f/255.f green:21.f/255.f blue:134.f/255.f alpha:0.0f];
        [accessibilityOff setTintColor:color];
        [accessibilityOn setTintColor:[UIColor blackColor]];
    }
    [self tryToStartDirection:YES];
}
    
- (void) show {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        if (@available(iOS 11.0, *)) {
            self->heightConstraint.constant = self.superview.safeAreaInsets.top + 8.0 + 40 + 8.0 + 40 + 8.0 + 32 + 8.0;
        } else {
            self->heightConstraint.constant = 8.0 + 40 + 8.0 + 40 + 8.0 + 32 + 8.0;
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
        [_delegate didStopDirection];
        [_delegate didPressBack];
    }
}
  
- (void) setFrom:(id<MWZDirectionPoint> _Nullable) fromValue {
    fromDirectionPoint = fromValue;
    if (fromValue == nil) {
        fromTextField.text = @"";
    }
    else if ([fromValue isKindOfClass:MWZPlace.class] || [fromValue isKindOfClass:MWZPlacelist.class]) {
        id<MWZObject> mapwizeObject = (id<MWZObject>) fromValue;
        fromTextField.text = [mapwizeObject titleForLanguage:[_delegate directionBarRequiresCurrentLanguage:self]];
    }
    else if ([fromValue isKindOfClass:MWZIndoorLocation.class]) {
        fromTextField.text = NSLocalizedString(@"Current location","");
    }
    [self tryToStartDirection:YES];
}
    
- (void) setTo:(id<MWZDirectionPoint> _Nullable) toValue {
    toDirectionPoint = toValue;
    if (toValue == nil) {
        toTextField.text = @"";
    }
    else if ([toValue isKindOfClass:MWZPlace.class] || [toValue isKindOfClass:MWZPlacelist.class]) {
        id<MWZObject> mapwizeObject = (id<MWZObject>) toValue;
        toTextField.text = [mapwizeObject titleForLanguage:[_delegate directionBarRequiresCurrentLanguage:self]];
    }
    else if ([toValue isKindOfClass:MWZIndoorLocation.class]) {
        toTextField.text = NSLocalizedString(@"Current location","");
    }
    [self tryToStartDirection:YES];
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
    ILIndoorLocation* userLocation = [_delegate directionBarRequiresUserLocation:self];
    if (userLocation && userLocation.floor) {
        currentLocationView = [[MWZComponentCurrentLocationView alloc] init];
        currentLocationView.translatesAutoresizingMaskIntoConstraints = NO;
        viewToTopConstraint = currentLocationView;
        [self.superview addSubview:currentLocationView];
        UITapGestureRecognizer *currentLocationViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLocationTapped:)];
        currentLocationViewGestureRecognizer.numberOfTapsRequired = 1;
        [currentLocationView addGestureRecognizer:currentLocationViewGestureRecognizer];
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
    [resultList setLanguage:[_delegate directionBarRequiresCurrentLanguage:self]];
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
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self->backView.alpha = 1.0f;
        self->resultList.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
}

- (void) currentLocationTapped:(UITapGestureRecognizer*) recognizer {
    [self setFrom:[[MWZIndoorLocation alloc] initWith:[_delegate directionBarRequiresUserLocation:self]]];
    [self closeResultList];
}

- (void) closeResultList {
    [swapButton setHidden:NO];
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
    [_delegate didStartLoading];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [_delegate directionBarRequiresCurrentVenue:self].identifier;
    params.query = query;
    params.objectClass = @[@"place"];
    params.universeId = [_delegate directionBarRequiresCurrentUniverse:self].identifier;
    [mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->resultList swapResults:searchResponse];
            [self.delegate didStopLoading];
        });
    } failure:^(NSError *error) {
        // TODO Should handle this
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStopLoading];
        });
    }];
}
    
- (void) searchTo:(NSString*) query {
    [_delegate didStartLoading];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [_delegate directionBarRequiresCurrentVenue:self].identifier;
    params.query = query;
    params.objectClass = @[@"place", @"placeList"];
    params.universeId = [_delegate directionBarRequiresCurrentUniverse:self].identifier;
    [mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->resultList swapResults:searchResponse];
            [self.delegate didStopLoading];
        });
    } failure:^(NSError *error) {
        // TODO Should handle this
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStopLoading];
        });
    }];
}
    
- (void) tryToStartDirection:(BOOL) newDirection {
    if (fromDirectionPoint == nil || toDirectionPoint == nil) {
        return;
    }
    [_delegate didStartLoading];;
    [mapwizeApi getDirectionWithFrom:fromDirectionPoint to:toDirectionPoint isAccessible:isAccessible success:^(MWZDirection *direction) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startDirection:direction from:self->fromDirectionPoint to:self->toDirectionPoint newDirection:newDirection];
            [self.delegate didStopLoading];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStopLoading];
        });
    }];
}

- (void) startDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to newDirection:(BOOL) newDirection {
    
    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
    options.centerOnStart = newDirection;
    options.displayEndMarker = YES;
    
    [_delegate didFindDirection:direction from:from to:to isAccessible:isAccessible];
    
    /*[self.mapwizePlugin stopNavigation];
    if ([from isKindOfClass:MWZIndoorLocation.class] && self.mapwizePlugin.userLocation && self.mapwizePlugin.userLocation.floor) {
        [self.mapwizePlugin startNavigation:direction options:options navigationUpdateHandler:^(double duration, double distance, double locationDelta) {
            if (locationDelta > 10 && self.mapwizePlugin.userLocation && self.mapwizePlugin.userLocation.floor) {
                [self tryToStartDirection:NO];
            }
            else {
                [self.delegate didUpdateDirectionInfo:direction.traveltime distance:direction.distance];
            }
        }];
    }
    else {
        [self.mapwizePlugin setFollowUserMode:NONE];
        [self.mapwizePlugin setDirection:direction options:options];
        [self.delegate didUpdateDirectionInfo:direction.traveltime distance:direction.distance];
    }
    
    if (newDirection) {
        [self.mapwizePlugin removeMarkers];
        [self.mapwizePlugin removePromotedPlacesForVenue:[self.mapwizePlugin getVenue]];
        [self.delegate didUpdateDirectionInfo:direction.traveltime distance:direction.distance];
        if ([to isKindOfClass:MWZPlace.class]) {
            [_mapwizePlugin addPromotedPlace:(MWZPlace*) to];
        }
        if ([from isKindOfClass:MWZPlace.class]) {
            [_mapwizePlugin addPromotedPlace:(MWZPlace*) from];
        }
    }*/
}
    
#pragma mark TextFieldDelegate
    
- (void) textFieldDidBeginEditing:(UITextField*) textField {
    [swapButton setHidden:YES];
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
