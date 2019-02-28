#import "MWZComponentBottomInfoView.h"
#import "MWZComponentIconTextButton.h"
#import "MWZComponentBottomInfoViewDelegate.h"

@implementation MWZComponentBottomInfoView {
    UILabel* title;
    UIImageView* icon;
    UILabel* subtitle;
    UIScrollView* detailsScrollView;
    UILabel* details;
    MWZComponentIconTextButton* directionButton;
    MWZComponentIconTextButton* informationsButton;
    UIView* separatorView;
    UIView* pullUpView;
    CGFloat minHeight;
    CGFloat maxHeight;
    CGFloat totalHeight;
    UIColor* color;
    
    NSLayoutConstraint* detailsToSubtitle;
    NSLayoutConstraint* detailsToTitle;
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
        [self addViews];
        [self setupConstraintsToViews];
        [self setupGestureRecognizer];
    }
    
    return self;
}

- (void) setupGestureRecognizer {
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:panGesture];
}

- (void) dragView:(UIPanGestureRecognizer*) sender {
    CGPoint translation = [sender translationInView:sender.view.superview];
    if (totalHeight-translation.y > maxHeight) {
        [self moveTo:maxHeight];
    }
    if (totalHeight-translation.y < minHeight) {
        [self moveTo:minHeight];
    }
    if (totalHeight-translation.y < maxHeight && totalHeight-translation.y > minHeight) {
        [self moveTo:totalHeight-translation.y];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        totalHeight -= translation.y;
        
        CGPoint velocity = [sender velocityInView:sender.view.superview];
        if (velocity.y < -500) {
            totalHeight = maxHeight;
            [self animateTo:totalHeight];
        }
        if (velocity.y > 500) {
            totalHeight = minHeight;
            [self animateTo:minHeight];
        }
    }
}

- (void) addViews {
    separatorView = [[UIView alloc] init];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:separatorView];
    
    pullUpView = [[UIView alloc] init];
    pullUpView.translatesAutoresizingMaskIntoConstraints = NO;
    pullUpView.backgroundColor = [UIColor lightGrayColor];
    pullUpView.layer.cornerRadius = 2.0f;
    [self addSubview:pullUpView];
    
    icon = [[UIImageView alloc] init];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [icon setTintColor:[UIColor lightGrayColor]];
    [self addSubview:icon];
    
    title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:title];
    
    subtitle = [[UILabel alloc] init];
    subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    subtitle.numberOfLines = 0;
    subtitle.textColor = [UIColor darkGrayColor];
    [subtitle setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:subtitle];
    
    detailsScrollView = [[UIScrollView alloc] init];
    detailsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:detailsScrollView];
    
    details = [[UILabel alloc] init];
    details.translatesAutoresizingMaskIntoConstraints = NO;
    details.numberOfLines = 0;
    [detailsScrollView addSubview:details];
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* image = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    directionButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Directions", @"") imageName:image color:color outlined:NO];
    directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [directionButton addTarget:self action:@selector(directionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:directionButton];
    
    UIImage* infoImage = [UIImage imageNamed:@"info" inBundle:bundle compatibleWithTraitCollection:nil];
    infoImage = [infoImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    informationsButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Information", @"") imageName:infoImage color:color outlined:YES];
    informationsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [informationsButton addTarget:self action:@selector(informationClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:informationsButton];
}

- (void) setupConstraintsToViews {
    
    [[NSLayoutConstraint constraintWithItem:pullUpView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:4.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:pullUpView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:pullUpView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:pullUpView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:4.0f] setActive:YES];
    
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
    
    [[NSLayoutConstraint constraintWithItem:detailsScrollView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:detailsScrollView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    detailsToTitle = [NSLayoutConstraint constraintWithItem:detailsScrollView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:title
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f];
    
    detailsToSubtitle = [NSLayoutConstraint constraintWithItem:detailsScrollView
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:subtitle
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0f
                                                   constant:16.0f];

    
    
    NSLayoutConstraint* topDetailsScrollViewMargin = [NSLayoutConstraint constraintWithItem:detailsScrollView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                                                    toItem:subtitle
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:16.0f];
    topDetailsScrollViewMargin.priority = 900;
    topDetailsScrollViewMargin.active = YES;
    
    NSLayoutConstraint* bottomDetailsScrollViewMargin = [NSLayoutConstraint constraintWithItem:detailsScrollView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                        toItem:directionButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1.0f
                                                                                      constant:-16.0f];
    bottomDetailsScrollViewMargin.priority = 900;
    bottomDetailsScrollViewMargin.active = YES;
    
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
                                   constant:36.f] setActive:YES];
    NSLayoutConstraint* t = [NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-16.f];
    t.priority = 998;
    t.active = YES;
    NSLayoutConstraint* directionConstraintToTitle = [NSLayoutConstraint constraintWithItem:directionButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                        toItem:title
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f
                                                                                      constant:16.0f];
    directionConstraintToTitle.priority = 1000;
    [directionConstraintToTitle setActive:YES];
    id directionConstraintToBottomItem;
    if (@available(iOS 11.0, *)) {
        directionConstraintToBottomItem = self.safeAreaLayoutGuide;
    } else {
        directionConstraintToBottomItem = self;
    }
    
    NSLayoutConstraint* directionConstraintToBottom = [NSLayoutConstraint constraintWithItem:directionButton
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:directionConstraintToBottomItem
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:1.0f
                                                                                    constant:-16.0f];
    directionConstraintToBottom.priority = 999;
    [directionConstraintToBottom setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:directionButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    
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
                                   constant:36.f] setActive:YES];

    
    NSLayoutConstraint* informationsConstraintToTitle = [NSLayoutConstraint constraintWithItem:informationsButton
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:title
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0f
                                                                                   constant:16.0f];
    informationsConstraintToTitle.priority = 1000;
    [informationsConstraintToTitle setActive:YES];
    
    
    NSLayoutConstraint* informationsConstraintToBottom = [NSLayoutConstraint constraintWithItem:informationsButton
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:directionButton
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                     multiplier:1.0f
                                                                                       constant:0];
    
    informationsConstraintToBottom.priority = 750;
    [informationsConstraintToBottom setActive:YES];
    
    
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
        totalHeight = 16.0f + 24.0f + 16.0f + 36.0f + self.safeAreaInsets.bottom + 16.0f;
    } else {
        totalHeight = 16.0f + 24.0f + 16.0f + 36.0f + 16.0f;
    }
    NSString* subtitleString = [place subtitleForLanguage:language];
    
    if (!subtitleString || [subtitleString length] == 0) {
        subtitleString = @"";
        detailsToSubtitle.active = NO;
        detailsToTitle.active = YES;
    }
    else {
        totalHeight += 16.0f;
        detailsToSubtitle.active = YES;
        detailsToTitle.active = NO;
    }
    
    NSAttributedString *attributedString = nil;
    if ([place detailsForLanguage:language] && [place detailsForLanguage:language].length > 0) {
        attributedString = [[NSAttributedString alloc]
                                                initWithData: [[place detailsForLanguage:language] dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        [pullUpView setHidden:NO];
        totalHeight += 40;
    }
    else {
        [pullUpView setHidden:YES];
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
    
    details.attributedText = attributedString;
    CGSize detailsSize = [details sizeThatFits:CGSizeMake(detailsScrollView.frame.size.width, CGFLOAT_MAX)];
    detailsScrollView.contentSize = detailsSize;
    CGSize size = [subtitle sizeThatFits:CGSizeMake(subtitle.frame.size.width, CGFLOAT_MAX)];
    totalHeight += size.height;
    minHeight = totalHeight;
    maxHeight = totalHeight;
    if (detailsSize.height > 0) {
        maxHeight += detailsSize.height + 32;
    }
    if (maxHeight > self.superview.frame.size.height - 24) {
        maxHeight = self.superview.frame.size.height - 24;
    }
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
        detailsToSubtitle.active = NO;
        detailsToTitle.active = YES;
    }
    else {
        totalHeight += 16.0f;
        detailsToSubtitle.active = YES;
        detailsToTitle.active = NO;
    }
    NSAttributedString *attributedString = nil;
    if ([placeList detailsForLanguage:language] && [placeList detailsForLanguage:language].length > 0) {
        attributedString = [[NSAttributedString alloc]
                            initWithData: [[placeList detailsForLanguage:language] dataUsingEncoding:NSUnicodeStringEncoding]
                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                            documentAttributes: nil
                            error: nil
                            ];
        [pullUpView setHidden:NO];
        totalHeight += 40;
    }
    else {
        [pullUpView setHidden:YES];
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
    
    details.attributedText = attributedString;
    CGSize detailsSize = [details sizeThatFits:CGSizeMake(detailsScrollView.frame.size.width, CGFLOAT_MAX)];
    detailsScrollView.contentSize = detailsSize;
    CGSize size = [subtitle sizeThatFits:CGSizeMake(subtitle.frame.size.width, CGFLOAT_MAX)];
    totalHeight += size.height;
    minHeight = totalHeight;
    maxHeight = totalHeight;
    if (detailsSize.height > 0) {
        maxHeight += detailsSize.height + 32;
    }
    if (maxHeight > self.superview.frame.size.height - 24) {
        maxHeight = self.superview.frame.size.height - 24;
    }
    [self animateTo:totalHeight];
}


- (void) unselectContent {
    [self animateTo:0.0f];
}

- (void) moveTo:(CGFloat) height {
    for (NSLayoutConstraint* c in self.constraints) {
        if (c.firstAttribute == NSLayoutAttributeHeight) {
            c.constant = height;
            [self.superview layoutIfNeeded];
        }
    }
    
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

@end
