#import "MWZDirectionHeader.h"
#import "MWZComponentBorderedTextField.h"
#import "MWZPaddingLabel.h"
#import "MWZPaddingTextField.h"

@interface MWZDirectionHeader () <UITextFieldDelegate>

@property (nonatomic) UIButton* backButton;
@property (nonatomic) UIButton* swapButton;
@property (nonatomic) UIButton* accessibilityOn;
@property (nonatomic) UIButton* accessibilityOff;
@property (nonatomic) MWZPaddingLabel* fromLabel;
@property (nonatomic) MWZPaddingLabel* toLabel;
@property (nonatomic) MWZPaddingTextField* fromTextField;
@property (nonatomic) MWZPaddingTextField* toTextField;
@property (nonatomic) UIImageView* fromPictoImageView;
@property (nonatomic) UIImageView* toPictoImageView;
@property (nonatomic) UIImage* backImage;
@property (nonatomic) UIImage* accessibilityOnImage;
@property (nonatomic) UIImage* accessibilityOffImage;
@property (nonatomic) UIImage* swapImage;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;

@end

@implementation MWZDirectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor greenColor];
        _haloColor = [UIColor yellowColor];
        [self initialize];
        [self setupConstraints];
    }
    return self;
}

- (void) initialize {
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
    
    self.toLabel = [[MWZPaddingLabel alloc] init];
    self.toLabel.leftInset = 16;
    self.toLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.toLabel.text = NSLocalizedString(@"Destination",@"");
    self.toLabel.clipsToBounds = NO;
    self.toLabel.layer.cornerRadius = 10;
    self.toLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.toLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.toLabel.layer.borderWidth = 0.5;
    self.toLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *toTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTo:)];
    toTapGesture.numberOfTapsRequired = 1;
    [self.toLabel addGestureRecognizer:toTapGesture];
    [self addSubview:self.toLabel];
    
    self.toTextField = [[MWZPaddingTextField alloc] init];
    self.toTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.toTextField.placeholder = NSLocalizedString(@"Destination",@"");
    self.toTextField.layer.cornerRadius = 10;
    self.toTextField.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.toTextField.layer.borderColor = [UIColor greenColor].CGColor;
    self.toTextField.layer.borderWidth = 2;
    self.toTextField.userInteractionEnabled = YES;
    [self addSubview:self.toTextField];
    [self.toTextField setHidden:YES];
    [self.toTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.fromLabel = [[MWZPaddingLabel alloc] init];
    self.fromLabel.leftInset = 16;
    self.fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromLabel.text = NSLocalizedString(@"Starting point",@"");
    self.fromLabel.clipsToBounds = NO;
    self.fromLabel.layer.cornerRadius = 10;
    self.fromLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.fromLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.fromLabel.layer.borderWidth = 0.5;
    self.fromLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *fromTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnFrom:)];
    fromTapGesture.numberOfTapsRequired = 1;
    [self.fromLabel addGestureRecognizer:fromTapGesture];
    [self addSubview:self.fromLabel];
    
    self.fromTextField = [[MWZPaddingTextField alloc] init];
    self.fromTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromTextField.placeholder = NSLocalizedString(@"Starting point",@"");
    self.fromTextField.layer.cornerRadius = 10;
    self.fromTextField.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.fromTextField.layer.borderColor = [UIColor greenColor].CGColor;
    self.fromTextField.layer.borderWidth = 2;
    [self addSubview:self.fromTextField];
    [self.fromTextField setHidden:YES];
    [self.fromTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) didTapOnFrom:(UITapGestureRecognizer*) recognizer {
    [_delegate directionHeaderDidTapOnFromButton:self];
}

- (void) didTapOnTo:(UITapGestureRecognizer*) recognizer {
    [_delegate directionHeaderDidTapOnToButton:self];
}

- (void) setupConstraints {
    self.clipsToBounds = NO;
    [self setBackgroundColor: [UIColor whiteColor]];
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.cornerRadius = 10;
    id topLayoutGuide = self;
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMaxYCorner;
        topLayoutGuide = self.safeAreaLayoutGuide;
    }
    
    
    
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
                                     toItem:self.fromLabel
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
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
    
    [[NSLayoutConstraint constraintWithItem:self.fromLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromPictoImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.fromLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:topLayoutGuide
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
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
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:topLayoutGuide
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
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
                                     toItem:self.toLabel
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.toLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.swapButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toPictoImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.toLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
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
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    ////////////
    
    [[NSLayoutConstraint constraintWithItem:self.accessibilityOff
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
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
                                     toItem:self.toLabel
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
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
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
                                     toItem:self.fromLabel
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
    
    [[NSLayoutConstraint constraintWithItem:self.swapButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.fromLabel
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:88.0f/2 - 16.0f] setActive:YES];
}

- (void) openFromSearch {
    [self.fromLabel setHidden:YES];
    [self.fromTextField setHidden:NO];
    [self.fromTextField becomeFirstResponder];
}

- (void) closeFromSearch {
    [self.fromLabel setHidden:NO];
    [self.fromTextField setHidden:YES];
    [self.fromTextField resignFirstResponder];
    self.fromTextField.text = @"";
}

- (void) openToSearch {
    [self.toLabel setHidden:YES];
    [self.toTextField setHidden:NO];
    [self.toTextField becomeFirstResponder];
}

- (void) closeToSearch {
    [self.toLabel setHidden:NO];
    [self.toTextField setHidden:YES];
    [self.toTextField resignFirstResponder];
    self.toTextField.text = @"";
}

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.fromLabel setText:text];
    if (asPlaceHolder) {
        [self.fromLabel setTextColor:[UIColor lightGrayColor]];
    }
    else {
        [self.fromLabel setTextColor:[UIColor blackColor]];
    }
}

-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.toLabel setText:text];
    if (asPlaceHolder) {
        [self.toLabel setTextColor:[UIColor lightGrayColor]];
    }
    else {
        [self.toLabel setTextColor:[UIColor blackColor]];
    }
}

-(void) setAccessibleMode:(BOOL) isAccessible {
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
}

- (void) setAccessibilityOn {
    [_delegate directionHeaderAccessibilityModeDidChange:YES];
}

- (void) setAccessibilityOff {
    [_delegate directionHeaderAccessibilityModeDidChange:NO];
}

- (void) backClick {
    [_delegate directionHeaderDidTapOnBackButton:self];
}

- (void) swapClick {
    [_delegate directionHeaderDidTapOnSwapButton:self];
}

- (void) textFieldDidChange:(UITextField*) textField {
    [_delegate searchDirectionQueryDidChange:textField.text];
}

@end
