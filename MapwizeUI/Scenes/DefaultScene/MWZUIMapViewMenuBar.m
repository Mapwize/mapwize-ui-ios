#import "MWZUIMapViewMenuBar.h"

@implementation MWZUIMapViewMenuBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

- (void) initialize {
    self.clipsToBounds = NO;
    self.layer.cornerRadius = 10;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
        
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* menuImage = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* directionImage = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    
    self.menuButton = [[UIButton alloc] init];
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.menuButton addTarget:self action:@selector(didTapOnMenuButton) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setImage:menuImage forState:UIControlStateNormal];
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
    
    [[NSLayoutConstraint constraintWithItem:self.menuButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    self.menuButton.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator setHidden:YES];
    [self addSubview:self.activityIndicator];
    
    [[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    self.directionButton = [[UIButton alloc] init];
    self.directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.directionButton setImage:directionImage forState:UIControlStateNormal];
    [self.directionButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.directionButton setHidden:YES];
    self.directionButton.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    [self.directionButton addTarget:self action:@selector(didTapOnDirectionButton) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.searchQueryLabel = [[UILabel alloc] init];
    self.searchQueryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchQueryLabel.textColor = [UIColor lightGrayColor];
    self.searchQueryLabel.text = NSLocalizedString(@"Search a venue...", "");
    self.searchQueryLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnSearch:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.searchQueryLabel addGestureRecognizer:tapGesture];
    
    [self addSubview:self.searchQueryLabel];
    [[NSLayoutConstraint constraintWithItem:self.searchQueryLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.directionButton
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchQueryLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchQueryLabel
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.searchQueryLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.menuButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
}

- (void) showActivityIndicator {
    [self.menuButton setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void) hideActivityIndicator {
    [self.menuButton setHidden:NO];
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

- (void) didTapOnSearch:(UITapGestureRecognizer*) recognizer {
    [_delegate didTapOnSearchButton];
}

- (void) didTapOnMenuButton {
    [_delegate didTapOnMenuButton];
}

- (void) didTapOnDirectionButton {
    [_delegate didTapOnDirectionButton];
}

@end
