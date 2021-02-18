#import "MWZUIDirectionHeader.h"
#import "MWZUIBorderedTextField.h"
#import "MWZUIPaddingLabel.h"
#import "MWZUIPaddingTextField.h"
#import "MWZUIDirectionModeSegment.h"
#import "MWZUIDirectionModeSegmentDelegate.h"
@interface MWZUIDirectionHeader () <UITextFieldDelegate, MWZUIDirectionModeSegmentDelegate>

@property (nonatomic) UIButton* backButton;
@property (nonatomic) UIButton* swapButton;
@property (nonatomic) MWZUIPaddingLabel* fromLabel;
@property (nonatomic) MWZUIPaddingLabel* toLabel;
@property (nonatomic) MWZUIPaddingTextField* fromTextField;
@property (nonatomic) MWZUIPaddingTextField* toTextField;
@property (nonatomic) UIImageView* fromPictoImageView;
@property (nonatomic) UIImageView* toPictoImageView;
@property (nonatomic) UIImage* backImage;
@property (nonatomic) UIImage* accessibilityOnImage;
@property (nonatomic) UIImage* accessibilityOffImage;
@property (nonatomic) UIImage* swapImage;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;
@property (nonatomic) MWZUIDirectionModeSegment* modeControl;

@end

@implementation MWZUIDirectionHeader

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*) mainColor {
    self = [super initWithFrame:frame];
    if (self) {
        _color = mainColor;
        _haloColor = mainColor;
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
    [self.fromPictoImageView setImage:[UIImage imageNamed:@"directionStart" inBundle:[NSBundle bundleForClass:MWZPlace.class] compatibleWithTraitCollection:nil]];
    [self addSubview:self.fromPictoImageView];
    
    self.toPictoImageView = [[UIImageView alloc] init];
    self.toPictoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toPictoImageView setImage:[UIImage imageNamed:@"directionEnd" inBundle:[NSBundle bundleForClass:MWZPlace.class] compatibleWithTraitCollection:nil]];
    [self addSubview:self.toPictoImageView];
    
    self.swapButton = [[UIButton alloc] init];
    self.swapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.swapButton addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [self.swapButton addTarget:self action:@selector(swapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.swapButton setImage:self.swapImage forState:UIControlStateNormal];
    [self addSubview:self.swapButton];
    
    self.backButton = [[UIButton alloc] init];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backButton addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:self.backImage forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    
    self.toLabel = [[MWZUIPaddingLabel alloc] init];
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
    
    self.toTextField = [[MWZUIPaddingTextField alloc] init];
    self.toTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.toTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.toTextField.placeholder = NSLocalizedString(@"Destination",@"");
    self.toTextField.layer.cornerRadius = 10;
    self.toTextField.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.toTextField.layer.borderColor = self.color.CGColor;
    self.toTextField.layer.borderWidth = 2;
    self.toTextField.userInteractionEnabled = YES;
    [self addSubview:self.toTextField];
    [self.toTextField setHidden:YES];
    [self.toTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.fromLabel = [[MWZUIPaddingLabel alloc] init];
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
    
    self.fromTextField = [[MWZUIPaddingTextField alloc] init];
    self.fromTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fromTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromTextField.placeholder = NSLocalizedString(@"Starting point",@"");
    self.fromTextField.layer.cornerRadius = 10;
    self.fromTextField.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.fromTextField.layer.borderColor = self.color.CGColor;
    self.fromTextField.layer.borderWidth = 2;
    [self addSubview:self.fromTextField];
    [self.fromTextField setHidden:YES];
    [self.fromTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.modeControl = [[MWZUIDirectionModeSegment alloc] initWithColor:self.color];
    self.modeControl.delegate = self;
    self.modeControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.modeControl];
}

- (void) setAvailableModes:(NSArray<MWZDirectionMode*>*) modes {
    [self.modeControl setModes:modes];
}

- (void) setSelectedMode:(MWZDirectionMode*) mode {
    [self.modeControl setSelectedMode:mode];
}

- (void) didTapOnFrom:(UITapGestureRecognizer*) recognizer {
    [_delegate directionHeaderDidTapOnFromButton:self];
    if (!self.fromTextField.isHidden) {
        [_delegate searchDirectionQueryDidChange:self.fromTextField.text];
    }
}

- (void) didTapOnTo:(UITapGestureRecognizer*) recognizer {
    [_delegate directionHeaderDidTapOnToButton:self];
    if (!self.toTextField.isHidden) {
        [_delegate searchDirectionQueryDidChange:self.toTextField.text];
    }
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
    
    
    [[NSLayoutConstraint constraintWithItem:self.modeControl
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.modeControl
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.modeControl
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.modeControl
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.modeControl
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
}

- (void) setButtonsHidden:(BOOL) isHidden {
    [self.swapButton setHidden:isHidden];
    //[self.modeControl setHidden:isHidden];
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
    //self.fromTextField.text = @"";
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
    //self.toTextField.text = @"";
}

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.fromLabel setText:text];
    if (asPlaceHolder) {
        [self.fromLabel setTextColor:[UIColor lightGrayColor]];
        [self.fromTextField setText:@""];
    }
    else {
        [self.fromLabel setTextColor:[UIColor blackColor]];
        [self.fromTextField setText:text];
    }
}

-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.toLabel setText:text];
    if (asPlaceHolder) {
        [self.toLabel setTextColor:[UIColor lightGrayColor]];
        [self.toTextField setText:@""];
    }
    else {
        [self.toLabel setTextColor:[UIColor blackColor]];
        [self.toTextField setText:text];
    }
}

-(void) directionModeSegment:(MWZUIDirectionModeSegment *)segment didChangeMode:(MWZDirectionMode *)mode {
    [_delegate directionHeaderDirectionModeDidChange:mode];
}

- (void) backClick {
    [_delegate directionHeaderDidTapOnBackButton:self];
}

- (void) clickDown:(UIButton*) sender {
    [UIButton animateWithDuration:0.2 animations:^{
        [sender setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    } completion:^(BOOL finished) {
        [sender setTransform:CGAffineTransformIdentity];
    }];
}

- (void) swapClick {
    [_delegate directionHeaderDidTapOnSwapButton:self];
}

- (void) textFieldDidChange:(UITextField*) textField {
    [_delegate searchDirectionQueryDidChange:textField.text];
}


@end
