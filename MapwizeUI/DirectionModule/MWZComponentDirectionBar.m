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

@property (nonatomic) UIButton* backButton;
@property (nonatomic) UIButton* swapButton;
@property (nonatomic) UIButton* accessibilityOn;
@property (nonatomic) UIButton* accessibilityOff;
@property (nonatomic) MWZComponentBorderedTextField* fromTextField;
@property (nonatomic) MWZComponentBorderedTextField* toTextField;
@property (nonatomic) UIView* backView;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) MWZComponentCurrentLocationView* currentLocationView;
@property (nonatomic, weak) MWZSearchData* searchData;
@property (nonatomic) UIImageView* fromPictoImageView;
@property (nonatomic) UIImageView* toPictoImageView;
@property (nonatomic) UIImage* backImage;
@property (nonatomic) UIImage* accessibilityOnImage;
@property (nonatomic) UIImage* accessibilityOffImage;
@property (nonatomic) UIImage* swapImage;
@property (nonatomic) NSLayoutConstraint* heightConstraint;
@property (nonatomic, assign) BOOL isInFromSearch;
@property (nonatomic, assign) BOOL isInToSearch;
@property (nonatomic) id<MWZDirectionPoint> fromDirectionPoint;
@property (nonatomic) id<MWZDirectionPoint> toDirectionPoint;
@property (nonatomic, assign) BOOL isAccessible;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;
@property (nonatomic, weak) id<MWZMapwizeApi> mapwizeApi;

@end

@implementation MWZComponentDirectionBar

- (instancetype) initWithMapwizeApi:(id<MWZMapwizeApi>) mapwizeApi
                         searchData:(MWZSearchData*) searchData
                              color:(UIColor*) color {
    self = [super init];
    if (self) {
        _searchData = searchData;
        _color = color;
        _mapwizeApi = mapwizeApi;
        [self addViews];
        [self setupConstraints];
    }
    return self;
}

- (void) addViews {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    self.backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    self.swapImage = [UIImage imageNamed:@"swap" inBundle:bundle compatibleWithTraitCollection:nil];
    self.accessibilityOnImage = [UIImage imageNamed:@"accessibilityOn" inBundle:bundle compatibleWithTraitCollection:nil];
    self.accessibilityOnImage = [self.accessibilityOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.accessibilityOffImage = [UIImage imageNamed:@"accessibilityOff" inBundle:bundle compatibleWithTraitCollection:nil];
    self.accessibilityOffImage = [self.accessibilityOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.fromPictoImageView = [[UIImageView alloc] init];
    self.fromPictoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fromPictoImageView setImage:[UIImage imageNamed:@"followOff" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self addSubview:self.fromPictoImageView];
    
    self.toPictoImageView = [[UIImageView alloc] init];
    self.toPictoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toPictoImageView setImage:[UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self addSubview:self.toPictoImageView];
    
    self.accessibilityOff = [[UIButton alloc] init];
    self.accessibilityOff.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accessibilityOff setImage:self.accessibilityOffImage forState:UIControlStateNormal];
    [self.accessibilityOff.imageView setContentMode:UIViewContentModeScaleAspectFit];
    CGFloat redComponent = CGColorGetComponents(self.color.CGColor)[0];
    CGFloat greenComponent = CGColorGetComponents(self.color.CGColor)[1];
    CGFloat blueComponent = CGColorGetComponents(self.color.CGColor)[2];
    self.haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
    self.accessibilityOff.backgroundColor = self.haloColor;
    self.accessibilityOff.layer.cornerRadius = 16.0;
    self.accessibilityOff.layer.masksToBounds = YES;
    self.accessibilityOff.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
    [self.accessibilityOff addTarget:self action:@selector(setAccessibilityOff) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.accessibilityOff];
    
    self.accessibilityOn = [[UIButton alloc] init];
    self.accessibilityOn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accessibilityOn setImage:self.accessibilityOnImage forState:UIControlStateNormal];
    [self.accessibilityOn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.accessibilityOn.layer.cornerRadius = 16.0;
    self.accessibilityOn.layer.masksToBounds = YES;
    self.accessibilityOn.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
    [self.accessibilityOn addTarget:self action:@selector(setAccessibilityOn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.accessibilityOn];
    
    self.swapButton = [[UIButton alloc] init];
    self.swapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.swapButton addTarget:self action:@selector(swapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.swapButton setImage:self.swapImage forState:UIControlStateNormal];
    [self addSubview:self.swapButton];
    
    self.backButton = [[UIButton alloc] init];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:self.backImage forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    
    self.toTextField = [[MWZComponentBorderedTextField alloc] init];
    self.toTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.toTextField.placeholder = NSLocalizedString(@"Destination","");
    self.toTextField.delegate = self;
    [self.toTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.toTextField];
    
    self.fromTextField = [[MWZComponentBorderedTextField alloc] init];
    self.fromTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromTextField.placeholder = NSLocalizedString(@"Starting point","");
    self.fromTextField.delegate = self;
    [self.fromTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.fromTextField];
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
    
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toTextField
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:0.66f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:72.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOn
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOn
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromTextField
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.33f
                                   constant:0.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOn
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOn
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:72.0f] setActive:YES];
    
    
    [[NSLayoutConstraint constraintWithItem:self.swapButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.swapButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.swapButton
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.backButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.fromTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromTextField
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toTextField
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:16.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.backButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toTextField
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.toTextField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toTextField
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toTextField
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toTextField
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.backButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromTextField
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.swapButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromTextField
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:88.0f/2 - 16.0f] setActive:YES];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:0.f];
    [self.heightConstraint setActive:YES];
    
    [self setAccessibility:NO];
}

- (void) setAccessibility:(BOOL) isAccessible {
    self.isAccessible = isAccessible;
    if (isAccessible) {
        [self.accessibilityOn setTintColor:self.color];
        [self.accessibilityOff setTintColor:[UIColor blackColor]];
        self.accessibilityOff.backgroundColor = [UIColor colorWithRed:197.f/255.f green:21.f/255.f blue:134.f/255.f alpha:0.0f];
        self.accessibilityOn.backgroundColor = self.haloColor;
    }
    else {
        self.accessibilityOff.backgroundColor = self.haloColor;
        self.accessibilityOn.backgroundColor = [UIColor colorWithRed:197.f/255.f green:21.f/255.f blue:134.f/255.f alpha:0.0f];
        [self.accessibilityOff setTintColor:self.color];
        [self.accessibilityOn setTintColor:[UIColor blackColor]];
    }
    [self tryToStartDirection:YES];
}

- (void) show {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        if (@available(iOS 11.0, *)) {
            self.heightConstraint.constant = self.superview.safeAreaInsets.top + 8.0 + 40 + 8.0 + 40 + 8.0 + 32 + 8.0;
        } else {
            self.heightConstraint.constant = 8.0 + 40 + 8.0 + 40 + 8.0 + 32 + 8.0;
        }
        [self.superview layoutIfNeeded];
    }];
}

- (void) hide {
    self.fromDirectionPoint = nil;
    self.fromTextField.text = @"";
    self.toDirectionPoint = nil;
    self.toTextField.text = @"";
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.heightConstraint.constant = 0.0f;
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
    id<MWZDirectionPoint> tmpFrom = self.fromDirectionPoint;
    id<MWZDirectionPoint> tmpTo = self.toDirectionPoint;
    [self setFrom:nil];
    [self setTo:nil];
    [self setFrom:tmpTo];
    [self setTo:tmpFrom];
}

- (void) backClick {
    if (self.isInFromSearch) {
        [self setTextFieldValue:_fromTextField forDirectionPoint:_fromDirectionPoint];
        [self closeResultList];
    }
    else if (self.isInToSearch) {
        [self setTextFieldValue:_toTextField forDirectionPoint:_toDirectionPoint];
        [self closeResultList];
    }
    else {
        [self.delegate didStopDirection];
        [self.delegate didPressBack];
    }
}

- (void) setFrom:(id<MWZDirectionPoint> _Nullable) fromValue {
    self.fromDirectionPoint = fromValue;
    [self setTextFieldValue:_fromTextField forDirectionPoint:_fromDirectionPoint];
    [self tryToStartDirection:YES];
}

- (void) setTo:(id<MWZDirectionPoint> _Nullable) toValue {
    self.toDirectionPoint = toValue;
    [self setTextFieldValue:_toTextField forDirectionPoint:_toDirectionPoint];
    [self tryToStartDirection:YES];
}

- (void) setTextFieldValue:(UITextField*) textField forDirectionPoint:(id<MWZDirectionPoint>) directionPoint {
    if (directionPoint == nil) {
        textField.text = @"";
    }
    else if ([directionPoint isKindOfClass:MWZPlace.class] || [directionPoint isKindOfClass:MWZPlacelist.class]) {
        id<MWZObject> mapwizeObject = (id<MWZObject>) directionPoint;
        textField.text = [mapwizeObject titleForLanguage:[self.delegate componentRequiresCurrentLanguage:self]];
    }
    else if ([directionPoint isKindOfClass:MWZIndoorLocation.class]) {
        textField.text = NSLocalizedString(@"Current location","");
    }
}

- (void) showResultList {
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backView.alpha = 0.0;
    [self.superview addSubview:self.backView];
    [self.superview bringSubviewToFront:self];
    [[NSLayoutConstraint constraintWithItem:self.backView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    NSLayoutConstraint* backViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.backView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.superview
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f
                                                                              constant:0.0f];
    [backViewTopConstraint setActive:YES];
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
    
    UIView* viewToTopConstraint;
    ILIndoorLocation* userLocation = [self.delegate componentRequiresUserLocation:self];
    if (userLocation && userLocation.floor) {
        self.currentLocationView = [[MWZComponentCurrentLocationView alloc] init];
        self.currentLocationView.translatesAutoresizingMaskIntoConstraints = NO;
        viewToTopConstraint = self.currentLocationView;
        [self.superview addSubview:self.currentLocationView];
        UITapGestureRecognizer *currentLocationViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLocationTapped:)];
        currentLocationViewGestureRecognizer.numberOfTapsRequired = 1;
        [self.currentLocationView addGestureRecognizer:currentLocationViewGestureRecognizer];
        [[NSLayoutConstraint constraintWithItem:self.currentLocationView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.backView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.currentLocationView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.backView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.currentLocationView
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
    self.resultList = [[MWZComponentResultList alloc] init];
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultList.alpha = 0.0f;
    [self.resultList setLanguage:[self.delegate componentRequiresCurrentLanguage:self]];
    self.resultList.resultDelegate = self;
    [self.backView addSubview:self.resultList];
    [[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.resultList
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:self.backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f - self.superview.safeAreaInsets.bottom];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    } else {
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:self.backView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f
                                                                             constant:-8.0f];
        bottomConstraint.priority = 700;
        [bottomConstraint setActive:YES];
    }
    NSLayoutConstraint* constraintToHeader = [NSLayoutConstraint constraintWithItem:self.resultList
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:viewToTopConstraint
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:8.0f];
    NSLayoutConstraint* constraintToBackView = [NSLayoutConstraint constraintWithItem:self.resultList
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
        self.backView.alpha = 1.0f;
        self.resultList.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
}

- (void) currentLocationTapped:(UITapGestureRecognizer*) recognizer {
    if (_isInFromSearch) {
        [self setFrom:[[MWZIndoorLocation alloc] initWith:[self.delegate componentRequiresUserLocation:self]]];
    }
    if (_isInToSearch) {
        [self setTo:[[MWZIndoorLocation alloc] initWith:[self.delegate componentRequiresUserLocation:self]]];
    }
    [self closeResultList];
}

- (void) closeResultList {
    [self.swapButton setHidden:NO];
    [self.fromTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
    self.isInToSearch = NO;
    self.isInFromSearch = NO;
    [UIView animateWithDuration:0.5 animations:^ {
        self.backView.alpha = 0.0f;
        self.resultList.alpha = 0.0f;
        self.currentLocationView.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.resultList removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.currentLocationView removeFromSuperview];
        self.resultList = nil;
        self.backView = nil;
        self.currentLocationView = nil;
    }];
}

- (void) loadEmptyFromSearch {
    [self.resultList swapResults:self.searchData.mainFrom];
}

- (void) loadEmptyToSearch {
    [self.resultList swapResults:self.searchData.mainSearch];
}

- (void) searchFrom:(NSString*) query {
    [self.delegate didStartLoading];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [self.delegate componentRequiresCurrentVenue:self].identifier;
    params.query = query;
    params.objectClass = @[@"place"];
    params.universeId = [self.delegate componentRequiresCurrentUniverse:self].identifier;
    [self.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultList swapResults:searchResponse];
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
    [self.delegate didStartLoading];
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.venueId = [self.delegate componentRequiresCurrentVenue:self].identifier;
    params.query = query;
    params.objectClass = @[@"place", @"placeList"];
    params.universeId = [self.delegate componentRequiresCurrentUniverse:self].identifier;
    [self.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultList swapResults:searchResponse];
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
    if (self.fromDirectionPoint == nil || self.toDirectionPoint == nil) {
        return;
    }
    [self.delegate didStartLoading];
    if ([_fromDirectionPoint isKindOfClass:MWZIndoorLocation.class]) {
        _fromDirectionPoint = [[MWZIndoorLocation alloc] initWith:[self.delegate componentRequiresUserLocation:self]];
    }
    [self.mapwizeApi getDirectionWithFrom:self.fromDirectionPoint to:self.toDirectionPoint isAccessible:self.isAccessible success:^(MWZDirection *direction) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startDirection:direction from:self.fromDirectionPoint to:self.toDirectionPoint newDirection:newDirection];
            [self.delegate didStopLoading];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStopLoading];
        });
    }];
}

- (void) didTapOnPlace:(MWZPlace*) place {
    if (!_fromDirectionPoint) {
        [self setFrom:place];
    }
    else if (!_toDirectionPoint) {
        [self setTo:place];
    }
}

- (void) startDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to newDirection:(BOOL) newDirection {
    [self.delegate didFindDirection:direction from:from to:to isAccessible:self.isAccessible];
}

#pragma mark TextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField*) textField {
    [self.swapButton setHidden:YES];
    if (!self.resultList) {
        [self showResultList];
    }
    [self setTextFieldValue:_fromTextField forDirectionPoint:_fromDirectionPoint];
    [self setTextFieldValue:_toTextField forDirectionPoint:_toDirectionPoint];
    textField.text = @"";
    
    if (textField == self.fromTextField) {
        self.isInToSearch = NO;
        self.isInFromSearch = YES;
        [self loadEmptyFromSearch];
    }
    else {
        self.isInFromSearch = NO;
        self.isInToSearch = YES;
        [self loadEmptyToSearch];
    }
}

- (void) textFieldDidChange:(UITextField*) textField {
    if (!self.isInFromSearch && !self.isInToSearch) {
        return;
    }
    if (textField == self.fromTextField) {
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
    if (self.isInFromSearch) {
        [self setFrom:(id<MWZDirectionPoint>)mapwizeObject];
    }
    if (self.isInToSearch) {
        [self setTo:(id<MWZDirectionPoint>)mapwizeObject];
    }
    [self closeResultList];
}

#pragma mark SafeAreaInsets

- (void) safeAreaInsetsDidChange {
    
}

@end
