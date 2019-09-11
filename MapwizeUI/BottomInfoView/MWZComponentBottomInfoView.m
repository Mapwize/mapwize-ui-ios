#import "MWZComponentBottomInfoView.h"
#import "MWZComponentIconTextButton.h"
#import "MWZComponentBottomInfoViewDelegate.h"

@interface MWZComponentBottomInfoView ()

@property (nonatomic) UILabel* title;
@property (nonatomic) UIImageView* icon;
@property (nonatomic) UILabel* subtitle;
@property (nonatomic) UIScrollView* detailsScrollView;
@property (nonatomic) UILabel* details;
@property (nonatomic) MWZComponentIconTextButton* directionButton;
@property (nonatomic) MWZComponentIconTextButton* informationsButton;
@property (nonatomic) UIView* separatorView;
@property (nonatomic) UIView* pullUpView;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat totalHeight;
@property (nonatomic) UIColor* color;
@property (nonatomic) NSLayoutConstraint* detailsToSubtitle;
@property (nonatomic) NSLayoutConstraint* detailsToTitle;

@end

@implementation MWZComponentBottomInfoView


- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    
    if (self) {
        _color = color;
        _totalHeight = 0.0f;
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
    if (self.totalHeight-translation.y > self.maxHeight) {
        [self moveTo:self.maxHeight];
    }
    if (self.totalHeight-translation.y < self.minHeight) {
        [self moveTo:self.minHeight];
    }
    if (self.totalHeight-translation.y < self.maxHeight && self.totalHeight-translation.y > self.minHeight) {
        [self moveTo:self.totalHeight-translation.y];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.totalHeight -= translation.y;
        
        CGPoint velocity = [sender velocityInView:sender.view.superview];
        if (velocity.y < -500) {
            self.totalHeight = self.maxHeight;
            [self animateTo:self.totalHeight];
        }
        if (velocity.y > 500) {
            self.totalHeight = self.minHeight;
            [self animateTo:self.minHeight];
        }
    }
}

- (void) addViews {
    self.separatorView = [[UIView alloc] init];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.separatorView];
    
    self.pullUpView = [[UIView alloc] init];
    self.pullUpView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pullUpView.backgroundColor = [UIColor lightGrayColor];
    self.pullUpView.layer.cornerRadius = 2.0f;
    [self addSubview:self.pullUpView];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.icon setTintColor:[UIColor lightGrayColor]];
    [self addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] init];
    self.subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitle.numberOfLines = 0;
    self.subtitle.textColor = [UIColor darkGrayColor];
    [self.subtitle setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.subtitle];
    
    self.detailsScrollView = [[UIScrollView alloc] init];
    self.detailsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.detailsScrollView];
    
    self.details = [[UILabel alloc] init];
    self.details.translatesAutoresizingMaskIntoConstraints = NO;
    self.details.numberOfLines = 0;
    [self.detailsScrollView addSubview:self.details];
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* image = [UIImage imageNamed:@"direction" inBundle:bundle compatibleWithTraitCollection:nil];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.directionButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Directions", @"") imageName:image color:self.color outlined:NO];
    self.directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.directionButton addTarget:self action:@selector(directionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.directionButton];
    
    UIImage* infoImage = [UIImage imageNamed:@"info" inBundle:bundle compatibleWithTraitCollection:nil];
    infoImage = [infoImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.informationsButton = [[MWZComponentIconTextButton alloc] initWithTitle:NSLocalizedString(@"Information", @"") imageName:infoImage color:self.color outlined:YES];
    self.informationsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.informationsButton addTarget:self action:@selector(informationClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.informationsButton];
}

- (void) setupConstraintsToViews {
    
    [[NSLayoutConstraint constraintWithItem:self.pullUpView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:4.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.pullUpView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.pullUpView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.pullUpView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:4.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.icon
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.icon
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.icon
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.icon
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.title
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.title
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.title
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.icon
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.title
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.subtitle
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:100.f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.subtitle
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.subtitle
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.subtitle
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.icon
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    self.detailsToTitle = [NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.title
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0f
                                                        constant:16.0f];
    
    self.detailsToSubtitle = [NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.subtitle
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:16.0f];
    
    
    
    NSLayoutConstraint* topDetailsScrollViewMargin = [NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                     toItem:self.subtitle
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0f
                                                                                   constant:16.0f];
    topDetailsScrollViewMargin.priority = 900;
    topDetailsScrollViewMargin.active = YES;
    
    NSLayoutConstraint* bottomDetailsScrollViewMargin = [NSLayoutConstraint constraintWithItem:self.detailsScrollView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                        toItem:self.directionButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1.0f
                                                                                      constant:-16.0f];
    bottomDetailsScrollViewMargin.priority = 900;
    bottomDetailsScrollViewMargin.active = YES;
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:36.f] setActive:YES];
    NSLayoutConstraint* t = [NSLayoutConstraint constraintWithItem:self.directionButton
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:-16.f];
    t.priority = 998;
    t.active = YES;
    NSLayoutConstraint* directionConstraintToTitle = [NSLayoutConstraint constraintWithItem:self.directionButton
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:self.title
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
    
    NSLayoutConstraint* directionConstraintToBottom = [NSLayoutConstraint constraintWithItem:self.directionButton
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:directionConstraintToBottomItem
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:1.0f
                                                                                    constant:-16.0f];
    directionConstraintToBottom.priority = 999;
    [directionConstraintToBottom setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.directionButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    
    [[NSLayoutConstraint constraintWithItem:self.informationsButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.directionButton
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.informationsButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:36.f] setActive:YES];
    
    
    NSLayoutConstraint* informationsConstraintToTitle = [NSLayoutConstraint constraintWithItem:self.informationsButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                        toItem:self.title
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f
                                                                                      constant:16.0f];
    informationsConstraintToTitle.priority = 1000;
    [informationsConstraintToTitle setActive:YES];
    
    
    NSLayoutConstraint* informationsConstraintToBottom = [NSLayoutConstraint constraintWithItem:self.informationsButton
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.directionButton
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
        self.totalHeight = 16.0f + 24.0f + 16.0f + 36.0f + self.safeAreaInsets.bottom + 16.0f;
    } else {
        self.totalHeight = 16.0f + 24.0f + 16.0f + 36.0f + 16.0f;
    }
    NSString* subtitleString = [place subtitleForLanguage:language];
    
    if (!subtitleString || [subtitleString length] == 0) {
        subtitleString = @"";
        self.detailsToSubtitle.active = NO;
        self.detailsToTitle.active = YES;
    }
    else {
        self.totalHeight += 16.0f;
        self.detailsToSubtitle.active = YES;
        self.detailsToTitle.active = NO;
    }
    
    NSAttributedString *attributedString = nil;
    if ([place detailsForLanguage:language] && [place detailsForLanguage:language].length > 0) {
        attributedString = [[NSAttributedString alloc]
                            initWithData: [[place detailsForLanguage:language] dataUsingEncoding:NSUnicodeStringEncoding]
                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                            documentAttributes: nil
                            error: nil
                            ];
        
        [self.pullUpView setHidden:NO];
        self.totalHeight += 40;
    }
    else {
        [self.pullUpView setHidden:YES];
    }
    
    [self.informationsButton setHidden:!showInfoButton];
    [UIView transitionWithView:self.icon
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.icon setImage:imagePlace];
                    } completion:nil];
    [UIView transitionWithView:self.title
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.title setText:[place titleForLanguage:language]];
                    } completion:nil];
    [UIView transitionWithView:self.subtitle
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.subtitle setText:subtitleString];
                    } completion:nil];
    
    self.details.attributedText = attributedString;
    CGSize detailsSize = [self.details sizeThatFits:CGSizeMake(self.detailsScrollView.frame.size.width, CGFLOAT_MAX)];
    self.detailsScrollView.contentSize = detailsSize;
    CGSize size = [self.subtitle sizeThatFits:CGSizeMake(self.subtitle.frame.size.width, CGFLOAT_MAX)];
    self.totalHeight += size.height;
    self.minHeight = self.totalHeight;
    self.maxHeight = self.totalHeight;
    if (detailsSize.height > 0) {
        self.maxHeight += detailsSize.height + 32;
    }
    if (self.maxHeight > self.superview.frame.size.height - 24) {
        self.maxHeight = self.superview.frame.size.height - 24;
    }
    [self animateTo:self.totalHeight];
}

- (void) selectContentWithPlaceList:(MWZPlacelist*) placeList language:(NSString*) language showInfoButton:(BOOL) showInfoButton {
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
        self.detailsToSubtitle.active = NO;
        self.detailsToTitle.active = YES;
    }
    else {
        totalHeight += 16.0f;
        self.detailsToSubtitle.active = YES;
        self.detailsToTitle.active = NO;
    }
    NSAttributedString *attributedString = nil;
    if ([placeList detailsForLanguage:language] && [placeList detailsForLanguage:language].length > 0) {
        attributedString = [[NSAttributedString alloc]
                            initWithData: [[placeList detailsForLanguage:language] dataUsingEncoding:NSUnicodeStringEncoding]
                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                            documentAttributes: nil
                            error: nil
                            ];
        [self.pullUpView setHidden:NO];
        totalHeight += 40;
    }
    else {
        [self.pullUpView setHidden:YES];
    }
    
    [self.informationsButton setHidden:!showInfoButton];
    [UIView transitionWithView:self.icon
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.icon setImage:imagePlacelist];
                    } completion:nil];
    [UIView transitionWithView:self.title
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.title setText:[placeList titleForLanguage:language]];
                    } completion:nil];
    [UIView transitionWithView:self.subtitle
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.subtitle setText:subtitleString];
                    } completion:nil];
    
    self.details.attributedText = attributedString;
    CGSize detailsSize = [self.details sizeThatFits:CGSizeMake(self.detailsScrollView.frame.size.width, CGFLOAT_MAX)];
    self.detailsScrollView.contentSize = detailsSize;
    CGSize size = [self.subtitle sizeThatFits:CGSizeMake(self.subtitle.frame.size.width, CGFLOAT_MAX)];
    totalHeight += size.height;
    self.minHeight = totalHeight;
    self.maxHeight = totalHeight;
    if (detailsSize.height > 0) {
        self.maxHeight += detailsSize.height + 32;
    }
    if (self.maxHeight > self.superview.frame.size.height - 24) {
        self.maxHeight = self.superview.frame.size.height - 24;
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
