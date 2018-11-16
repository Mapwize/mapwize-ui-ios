#import "MWZComponentBottomInfoView.h"
#import "MWZComponentIconTextButton.h"
#import "MWZComponentBottomInfoViewDelegate.h"

@implementation MWZComponentBottomInfoView {
    UILabel* title;
    UIImageView* icon;
    UILabel* subtitle;
    MWZComponentIconTextButton* directionButton;
    MWZComponentIconTextButton* informationsButton;
    CGFloat totalHeight;
    UIColor* color;
}


- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    
    if (self) {
        self->color = color;
        totalHeight = 0.0f;
        self.clipsToBounds = NO;
        self.layer.cornerRadius = 10;
        if (@available(iOS 11.0, *)) {
            self.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner;
        }
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowRadius = 4;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        [self initSubViews];
    }
    
    return self;
}

- (void) initSubViews {
    icon = [[UIImageView alloc] init];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [icon setTintColor:[UIColor lightGrayColor]];
    [self addSubview:icon];
    [[NSLayoutConstraint constraintWithItem:icon
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:icon
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:icon
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:icon
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:title];
    [[NSLayoutConstraint constraintWithItem:title
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:title
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:title
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:icon
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:title
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    subtitle = [[UILabel alloc] init];
    subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    subtitle.numberOfLines = 0;
    subtitle.textColor = [UIColor darkGrayColor];
    [subtitle setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:subtitle];
    [[NSLayoutConstraint constraintWithItem:subtitle
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:100.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:subtitle
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:subtitle
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:subtitle
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:icon
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* image = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    directionButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Direction", @"") imageName:image color:color outlined:NO];
    directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [directionButton addTarget:self action:@selector(directionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:directionButton];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];
    
    NSLayoutConstraint* directionConstraintToTitle = [NSLayoutConstraint constraintWithItem:directionButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                        toItem:title
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f
                                                                                      constant:16.0f];
    directionConstraintToTitle.priority = 1000;
    [directionConstraintToTitle setActive:YES];
    
    UIImage* infoImage = [UIImage imageNamed:@"info" inBundle:bundle compatibleWithTraitCollection:nil];
    infoImage = [infoImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    informationsButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Information", @"") imageName:infoImage color:color outlined:YES];
    informationsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [informationsButton addTarget:self action:@selector(informationClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:informationsButton];
    
    [[NSLayoutConstraint constraintWithItem:informationsButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:directionButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:informationsButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.f] setActive:YES];

    
    NSLayoutConstraint* informationsConstraintToTitle = [NSLayoutConstraint constraintWithItem:informationsButton
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:title
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0f
                                                                                   constant:16.0f];
    informationsConstraintToTitle.priority = 1000;
    [informationsConstraintToTitle setActive:YES];
    
    
    
    
}
    
- (void) directionClick {
    [_delegate didPressDirection];
}
    
- (void) informationClick {
    [_delegate didPressInformation];
}

- (void) selectContentWithPlace:(MWZPlace*) place language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* imagePlace = [UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil];
    imagePlace = [imagePlace imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (@available(iOS 11.0, *)) {
        totalHeight = 16.0f + 24.0f + 16.0f + 32.0f + self.safeAreaInsets.bottom + 16.0f;
    } else {
        totalHeight = 16.0f + 24.0f + 16.0f + 32.0f + 16.0f;
    }
    NSString* subtitleString = [place subtitleForLanguage:language];
    if (!subtitleString || [subtitleString length] == 0) {
        subtitleString = @"";
    }
    else {
        totalHeight += 16.0f;
    }
    [self->informationsButton setHidden:!showInfoButton];
    [UIView transitionWithView:icon
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->icon setImage:imagePlace];
                    } completion:nil];
    [UIView transitionWithView:title
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->title setText:[place titleForLanguage:language]];
                    } completion:nil];
    [UIView transitionWithView:subtitle
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->subtitle setText:subtitleString];
                    } completion:nil];
    
    CGSize size = [subtitle sizeThatFits:CGSizeMake(subtitle.frame.size.width, CGFLOAT_MAX)];
    totalHeight += size.height;
    
    [self animateTo:totalHeight];
}

- (void) selectContentWithPlaceList:(MWZPlaceList*) placeList language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* imagePlacelist = [UIImage imageNamed:@"menu" inBundle:bundle compatibleWithTraitCollection:nil];
    imagePlacelist = [imagePlacelist imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGFloat totalHeight;
    if (@available(iOS 11.0, *)) {
        totalHeight = 16.0f + 24.0f + 16.0f + 32.0f + self.safeAreaInsets.bottom + 16.0f;
    } else {
        totalHeight = 16.0f + 24.0f + 16.0f + 32.0f + 16.0f;
    }
    NSString* subtitleString = [placeList subtitleForLanguage:language];
    if (!subtitleString || [subtitleString length] == 0) {
        subtitleString = @"";
    }
    else {
        totalHeight += 16.0f;
    }
    [self->informationsButton setHidden:!showInfoButton];
    [UIView transitionWithView:icon
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->icon setImage:imagePlacelist];
                    } completion:nil];
    [UIView transitionWithView:title
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->title setText:[placeList titleForLanguage:language]];
                    } completion:nil];
    [UIView transitionWithView:subtitle
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self->subtitle setText:subtitleString];
                    } completion:nil];
    
    CGSize size = [subtitle sizeThatFits:CGSizeMake(subtitle.frame.size.width, CGFLOAT_MAX)];
    totalHeight += size.height;
    
    [self animateTo:totalHeight];
}


- (void) unselectContent {
    [self animateTo:0.0f];
}

- (void) animateTo:(CGFloat) height {
    for (NSLayoutConstraint* c in self.constraints) {
        if (c.firstAttribute == NSLayoutAttributeHeight) {
            [self.superview layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                c.constant = height;
                [self.superview layoutIfNeeded];
            }];
        }
    }
    
}

- (void) safeAreaInsetsDidChange {
    NSLayoutConstraint* directionConstraintToBottom = [NSLayoutConstraint constraintWithItem:directionButton
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:1.0f
                                                                                    constant:-16.0f - self.safeAreaInsets.bottom];
    directionConstraintToBottom.priority = 750;
    [directionConstraintToBottom setActive:YES];
    
    NSLayoutConstraint* informationsConstraintToBottom = [NSLayoutConstraint constraintWithItem:informationsButton
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:1.0f
                                                                                    constant:-16.0f - self.safeAreaInsets.bottom];
    informationsConstraintToBottom.priority = 750;
    [informationsConstraintToBottom setActive:YES];
}

@end
