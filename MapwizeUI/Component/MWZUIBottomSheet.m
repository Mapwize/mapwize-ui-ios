#import "MWZUIBottomSheet.h"
#import "MWZUICollectionViewCell.h"
#import "MWZUIDefaultContentView.h"
#import "MWZUIFullContentView.h"
#import "MWZUIBottomSheetComponents.h"
#import "MWZPlaceDetails.h"

@interface MWZUIBottomSheet () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (assign) CGFloat currentTranslation;
@property (assign) CGFloat initialTranslation;
@property (nonatomic) UIView* headerView;
@property (nonatomic) UIButton* closeButton;
@property (nonatomic) UICollectionView* headerImageCollectionView;
@property (nonatomic) UIView* contentView;
@property (nonatomic) UIView* dragSymbolView;
@property (nonatomic) UIView* dragSymbolViewContent;
@property (nonatomic) MWZUIDefaultContentView* defaultContentView;
@property (nonatomic) MWZUIFullContentView* fullContentView;

@property (nonatomic) MWZPlaceDetails* placeDetails;
@property (nonatomic) MWZPlacePreview* placePreview;
// STATE : HIDDEN, SMALL, SMALL+HEADER, FULL
//         0,      100,   200,          FULL


@property (assign) CGFloat defaultContentHeight;
@property (assign) CGFloat defaultHeaderHeight;
@property (assign) CGFloat minimizedContentHeight;
@property (assign) CGFloat minimizedHeaderHeight;
@property (assign) CGFloat maximizedContentHeight;
@property (assign) CGFloat maximizedHeaderHeight;
@property (nonatomic) NSLayoutConstraint* headerHeightConstraint;
@property (nonatomic) NSLayoutConstraint* selfTopConstraint;
@property (nonatomic) NSLayoutConstraint* dragSymbolHeightConstraint;

@property (nonatomic) CGRect parentFrame;
@property (nonatomic) UIColor* color;

@end

@implementation MWZUIBottomSheet

- (instancetype)initWithFrame:(CGRect) frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentFrame = frame;
        _color = color;
        //self.transform = CGAffineTransformMakeTranslation(0, _parentFrame.size.height);
        [self setupGestureRecognizer];
        [self setDefaultValuesFromFrame:frame];
        
    }
    return self;
}

- (void) setDefaultValuesFromFrame:(CGRect) parentFrame {
    _defaultContentHeight = 150;
    _defaultHeaderHeight = 90;
    _minimizedContentHeight = 100.0;
    _minimizedHeaderHeight = 0.0;
    _maximizedContentHeight = parentFrame.size.height * 2/3;
    _maximizedHeaderHeight = parentFrame.size.height * 1/3;
}

- (void) didMoveToSuperview {
    [self setupViews];
}

- (void) removeContent {
    _placePreview = nil;
    _placeDetails = nil;
    [self animateToHeight:0];
}

- (void) showPlacePreview:(MWZPlacePreview*)placePreview {
    _placePreview = placePreview;
    [_headerImageCollectionView reloadData];
    [_defaultContentView removeFromSuperview];
    [_fullContentView removeFromSuperview];
    [_dragSymbolViewContent setHidden:YES];
    _defaultContentView = [[MWZUIDefaultContentView alloc] initWithFrame:self.frame color:_color];
    _defaultContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_defaultContentView];
    [[_defaultContentView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor] setActive:YES];
    [[_defaultContentView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor] setActive:YES];
    [[_defaultContentView.topAnchor constraintEqualToAnchor:_contentView.topAnchor] setActive:YES];
    [_defaultContentView setPlacePreview:placePreview];
    [_defaultContentView layoutIfNeeded];
    if (@available(iOS 11.0, *)) {
        self.defaultContentHeight = _defaultContentView.frame.size.height + self.safeAreaInsets.bottom;
    } else {
        self.defaultContentHeight = _defaultContentView.frame.size.height;
    }
    if (!_placeDetails) {
        [self animateToHeight:self.defaultContentHeight];
    }
    _placeDetails = nil;
}

- (void) showPlacelist:(MWZPlacelist*)placelist shouldShowInformationButton:(BOOL) shouldShowInformationButton language:(NSString*)language {
    _placeDetails = nil;
    _placePreview = nil;
    [_defaultContentView removeFromSuperview];
    [_fullContentView removeFromSuperview];
    _fullContentView = nil;
    [_dragSymbolViewContent setHidden:YES];
    _defaultContentView = [[MWZUIDefaultContentView alloc] initWithFrame:self.frame color:_color];
    _defaultContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _defaultContentView.delegate = self;
    [_contentView addSubview:_defaultContentView];
    [[_defaultContentView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor] setActive:YES];
    [[_defaultContentView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor] setActive:YES];
    [[_defaultContentView.topAnchor constraintEqualToAnchor:_contentView.topAnchor] setActive:YES];
    
    NSMutableArray<MWZUIIconTextButton*>* buttons = [_defaultContentView buildButtonsForPlacelist:placelist showInfoButton:shouldShowInformationButton];
    
    [_defaultContentView setContentForPlacelist:placelist language:language buttons:buttons];
    [_defaultContentView layoutIfNeeded];
    if (@available(iOS 11.0, *)) {
        self.defaultContentHeight = _defaultContentView.frame.size.height + self.safeAreaInsets.bottom;
    } else {
        self.defaultContentHeight = _defaultContentView.frame.size.height;
    }
    if (!_placeDetails) {
        [self animateToHeight:self.defaultContentHeight];
    }
}

- (void) showPlaceDetails:(MWZPlaceDetails*)placeDetails shouldShowInformationButton:(BOOL) shouldShowInformationButton language:(NSString*)language {
    _placePreview = nil;
    _placeDetails = placeDetails;
    [_headerImageCollectionView reloadData];
    [_defaultContentView removeFromSuperview];
    [_fullContentView removeFromSuperview];
    [_dragSymbolViewContent setHidden:NO];
    _defaultContentView = [[MWZUIDefaultContentView alloc] initWithFrame:self.frame color:_color];
    _defaultContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_defaultContentView];
    [[_defaultContentView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor] setActive:YES];
    [[_defaultContentView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor] setActive:YES];
    [[_defaultContentView.topAnchor constraintEqualToAnchor:_contentView.topAnchor] setActive:YES];
    
    _fullContentView = [[MWZUIFullContentView alloc] initWithFrame:self.frame color:_color];
    _fullContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_fullContentView];
    [[_fullContentView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor] setActive:YES];
    [[_fullContentView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor] setActive:YES];
    [[_fullContentView.topAnchor constraintEqualToAnchor:_contentView.topAnchor] setActive:YES];
    [[_fullContentView.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor] setActive:YES];
    [[_fullContentView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    [_fullContentView setHidden:YES];
    _fullContentView.alpha = 0.0;
    
    NSMutableArray<MWZUIIconTextButton*>* minimizedViewButtons = [_defaultContentView buildButtonsForPlaceDetails:_placeDetails showInfoButton:shouldShowInformationButton];
    NSMutableArray<MWZUIFullContentViewComponentButton*>* fullHeaderButtons = [_fullContentView buildHeaderButtonsForPlaceDetails:_placeDetails  showInfoButton:shouldShowInformationButton language:language];
    NSMutableArray<MWZUIFullContentViewComponentRow*>* fullRows = [_fullContentView buildContentRowsForPlaceDetails:_placeDetails language:language];
    MWZUIBottomSheetComponents* components = [[MWZUIBottomSheetComponents alloc] initWithHeaderButtons:fullHeaderButtons contentRows:fullRows minimizedViewButtons:minimizedViewButtons];
    if (_delegate && [_delegate respondsToSelector:@selector(requireComponentForPlaceDetails:withDefaultComponents:)]) {
        components = [_delegate requireComponentForPlaceDetails:_placeDetails withDefaultComponents:components];
    }
    
    [_defaultContentView setContentForPlaceDetails:_placeDetails language:language buttons:components.minimizedViewButtons];;
    [_fullContentView setContentForPlaceDetails:_placeDetails language:language buttons:components.headerButtons rows:components.contentRows];
    
    [_defaultContentView layoutIfNeeded];
    if (@available(iOS 11.0, *)) {
        self.defaultContentHeight = _defaultContentView.frame.size.height + self.safeAreaInsets.bottom;
    } else {
        self.defaultContentHeight = _defaultContentView.frame.size.height;
    }
    if (_placeDetails.photos && _placeDetails.photos.count > 0) {
        _maximizedHeaderHeight = _parentFrame.size.height * 1/3;
        [self animateToHeight:self.defaultHeaderHeight + self.defaultContentHeight];
    }
    else {
        _maximizedHeaderHeight = 0;
        [self animateToHeight:self.defaultContentHeight];
    }
    
    _fullContentView.delegate = self;
    _defaultContentView.delegate = self;
}

- (void) setupViews {
    _selfTopConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:_parentFrame.size.height];
    [_selfTopConstraint setActive:YES];
    [[self.heightAnchor constraintEqualToConstant:self.maximizedHeaderHeight + self.maximizedContentHeight] setActive:YES];
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerView.backgroundColor = [UIColor clearColor];
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    [self addSubview:_contentView];
    
    [[_headerView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[_headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    _headerHeightConstraint = [_headerView.heightAnchor constraintEqualToConstant:0];
    [_headerHeightConstraint setActive:YES];
    
    _dragSymbolView = [[UIView alloc] initWithFrame:CGRectZero];
    _dragSymbolView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dragSymbolView];
    [[_dragSymbolView.topAnchor constraintEqualToAnchor:_headerView.bottomAnchor] setActive:YES];
    _dragSymbolHeightConstraint = [_dragSymbolView.heightAnchor constraintEqualToConstant:16.0];
    [_dragSymbolHeightConstraint setActive:YES];
    [[_dragSymbolView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_dragSymbolView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    _dragSymbolView.backgroundColor = [UIColor whiteColor];
    
    _dragSymbolViewContent = [[UIView alloc] initWithFrame:CGRectZero];
    _dragSymbolViewContent.translatesAutoresizingMaskIntoConstraints = NO;
    _dragSymbolViewContent.layer.cornerRadius = 2;
    _dragSymbolViewContent.layer.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    [_dragSymbolView addSubview:_dragSymbolViewContent];
    [[_dragSymbolViewContent.heightAnchor constraintEqualToConstant:4] setActive:YES];
    [[_dragSymbolViewContent.widthAnchor constraintEqualToConstant:40] setActive:YES];
    [[_dragSymbolViewContent.centerYAnchor constraintEqualToAnchor:_dragSymbolView.centerYAnchor] setActive:YES];
    [[_dragSymbolViewContent.centerXAnchor constraintEqualToAnchor:_dragSymbolView.centerXAnchor] setActive:YES];
    
    [[_contentView.topAnchor constraintEqualToAnchor:_dragSymbolView.bottomAnchor] setActive:YES];
    [[_contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[_contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.75] setActive:YES];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.height/3, self.frame.size.height/3);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _headerImageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _headerImageCollectionView.dataSource = self;
    _headerImageCollectionView.delegate = self;
    _headerImageCollectionView.backgroundColor = [UIColor whiteColor];
    _headerImageCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerImageCollectionView.showsVerticalScrollIndicator = NO;
    _headerImageCollectionView.showsHorizontalScrollIndicator = NO;
    [_headerView addSubview:_headerImageCollectionView];
    [[_headerImageCollectionView.topAnchor constraintEqualToAnchor:_headerView.topAnchor] setActive:YES];
    [[_headerImageCollectionView.trailingAnchor constraintEqualToAnchor:_headerView.trailingAnchor] setActive:YES];
    [[_headerImageCollectionView.leadingAnchor constraintEqualToAnchor:_headerView.leadingAnchor] setActive:YES];
    [[_headerImageCollectionView.bottomAnchor constraintEqualToAnchor:_headerView.bottomAnchor] setActive:YES];
    [_headerImageCollectionView registerClass:[MWZUICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addSubview:_closeButton];
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* backImage = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    [_closeButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setImage:[backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _closeButton.layer.cornerRadius = 20;
    _closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _closeButton.tintColor = [UIColor whiteColor];
    //_closeButton.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [[_closeButton.topAnchor constraintEqualToAnchor:_headerView.safeAreaLayoutGuide.topAnchor constant:16.0] setActive:YES];
    } else {
        [[_closeButton.topAnchor constraintEqualToAnchor:_headerView.topAnchor constant:16.0] setActive:YES];
    }
    [[_closeButton.leadingAnchor constraintEqualToAnchor:_headerView.leadingAnchor constant:16.0] setActive:YES];
    [[_closeButton.heightAnchor constraintEqualToConstant:40.0] setActive:YES];
    [[_closeButton.widthAnchor constraintEqualToConstant:40.0] setActive:YES];
    [_closeButton setHidden:YES];
    _closeButton.alpha = 0;
    
    
}

- (void) backClick {
    [_fullContentView setHidden:NO];
    [_defaultContentView setHidden:NO];
    [_closeButton setHidden:NO];
    [self animateToHeight:_defaultContentHeight + _defaultHeaderHeight];
}

- (void) setupGestureRecognizer {
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleView:)];
    [self addGestureRecognizer:tapGesture];
}

- (void) toggleView:(UIPanGestureRecognizer*) sender {
    if (!_fullContentView) {
        return;
    }
    if (_selfTopConstraint.constant != 0) {
        [_fullContentView setHidden:NO];
        [_defaultContentView setHidden:NO];
        [_closeButton setHidden:NO];
        [self animateToHeight:_maximizedHeaderHeight + _maximizedContentHeight];
    }
}

- (void) dragView:(UIPanGestureRecognizer*) sender {
    if (!_fullContentView) {
        return;
    }
    CGPoint translation = [sender translationInView:sender.view.superview];
    if (sender.state == UIGestureRecognizerStateBegan) {
        _currentTranslation = self.frame.origin.y;
        [_defaultContentView setHidden:NO];
        [_fullContentView setHidden:NO];
        [_closeButton setHidden:NO];
    }
    if (self.frame.size.height - _currentTranslation - translation.y < self.frame.size.height) {
        [self updateHeight:self.frame.size.height - _currentTranslation - translation.y];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        /*CGPoint velocity = [sender velocityInView:sender.view.superview];
        if (velocity.y < -500) {
            [self animateTo:0];
            return;
        }
        if (velocity.y > 500) {
            if (_fullHeight - _currentTranslation > _smallHeight) {
                [self animateTo:_fullHeight-_smallHeight];
            }
            else {
                [self animateTo:_fullHeight];
            }
            return;
        }*/
        
        
        double nextHeight = self.frame.size.height - _currentTranslation - translation.y;
        double closestHeight = self.frame.size.height;
        double closestDistance = fabs(nextHeight - closestHeight);
        
        if (fabs(nextHeight - self.defaultContentHeight - self.defaultHeaderHeight) < closestDistance) {
            closestDistance = fabs(nextHeight - self.defaultContentHeight - self.defaultHeaderHeight);
            closestHeight = self.defaultContentHeight + self.defaultHeaderHeight;
        }
        
        if (fabs(nextHeight - self.defaultContentHeight) < closestDistance) {
            closestDistance = fabs(nextHeight - self.defaultContentHeight);
            closestHeight = self.defaultContentHeight;
        }
        
        if (fabs(nextHeight - 0) < closestDistance) {
            closestHeight = 0;
            if (_delegate) {
                [_delegate didClose];
            }
        }
        
        
        
        [self animateToHeight:closestHeight];

    }
}

-(double) headerHeightFormula:(double)x {
    // 0:1
    // default:1
    // full : 0
    if (x <= self.defaultContentHeight + self.defaultHeaderHeight) {
        double x0 = self.defaultContentHeight;
        double x1 = self.defaultContentHeight + self.defaultHeaderHeight;
        double f0 = 0;
        double f1 = self.defaultHeaderHeight;
        return f0*((x-x1)/(x0-x1)) + f1*((x-x0)/(x1-x0));
    }
    else {
        double x0 = self.defaultContentHeight + self.defaultHeaderHeight;
        double x1 = self.frame.size.height;
        double f0 = self.defaultHeaderHeight;
        double f1 = self.frame.size.height / 4;
        return f0*((x-x1)/(x0-x1)) + f1*((x-x0)/(x1-x0));
    }
}

-(double) alphaFormula:(double)x {
    // 0:1
    // default:1
    // full : 0
    double x0 = 0;
    double x1 = self.defaultHeaderHeight + self.defaultContentHeight;
    double x2 = self.frame.size.height * 2 / 3;
    double f0 = 1;
    double f1 = 1;
    double f2 = 0;
    return f0*((x-x1)/(f0-x1))*((x-x2)/(f0-x2)) + f1*((x-x0)/(x1-x0))*((x-x2)/(x1-x2)) +
        f2*((x-x0)/(x2-x0))*((x-x1)/(x2-x1));
}

-(double) reversedAlphaFormula:(double)x {
    // 0:1
    // default:1
    // full : 0
    double x0 = 0;
    double x1 = self.frame.size.height * 2 / 3;
    double x2 = self.frame.size.height;
    double f0 = 0;
    double f1 = 0;
    double f2 = 1;
    return f0*((x-x1)/(f0-x1))*((x-x2)/(f0-x2)) + f1*((x-x0)/(x1-x0))*((x-x2)/(x1-x2)) +
        f2*((x-x0)/(x2-x0))*((x-x1)/(x2-x1));
}

- (void) updateHeight:(CGFloat) height {
    //self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height - height);
    _selfTopConstraint.constant = self.frame.size.height - height;
    _headerHeightConstraint.constant = [self headerHeightFormula:height];
    _defaultContentView.alpha = [self alphaFormula:height];
    _fullContentView.alpha = [self reversedAlphaFormula:height];
    self.closeButton.alpha = [self reversedAlphaFormula:height];
}

- (void) animateToHeight:(CGFloat) height {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        //self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height - height);
        self.selfTopConstraint.constant = self.frame.size.height - height;
        self.headerHeightConstraint.constant = [self headerHeightFormula:height];
        self.defaultContentView.alpha = [self alphaFormula:height];
        self.fullContentView.alpha = [self reversedAlphaFormula:height];
        self.closeButton.alpha = [self reversedAlphaFormula:height];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.defaultContentView.alpha < 0.1) {
            [self.defaultContentView setHidden:YES];
            [self.closeButton setHidden:NO];
        }
        if (self.fullContentView.alpha < 0.1) {
            [self.fullContentView setHidden:YES];
            [self.closeButton setHidden:YES];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MWZUICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MWZUICollectionViewCell alloc] init];
    }
    if (!_placeDetails || !_placeDetails.photos.count || _placeDetails.photos.count <= indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"imagePlaceholder"
                                          inBundle:[NSBundle bundleForClass:self.class]
                     compatibleWithTraitCollection:nil];
        return cell;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.placeDetails.photos[indexPath.row]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (imgData)
            {
                //Load the data into an UIImage:
                UIImage *image = [UIImage imageWithData:imgData];

                //Check if your image loaded successfully:
                if (image)
                {
                    cell.imageView.image = image;
                    /*[cell.superview layoutSubviews];
                    [UIView animateWithDuration:0.15 animations:^{
                        cell.imageView.alpha = 0;
                                        } completion:^(BOOL finished) {
                                            cell.imageView.image = image;
                                            [UIView animateWithDuration:0.15 animations:^{
                                                cell.imageView.alpha = 1;
                                            }];
                                        }];*/
                }
                else
                {
                    cell.imageView.image = [UIImage imageNamed:@"imagePlaceholder"
                                                      inBundle:[NSBundle bundleForClass:self.class]
                                 compatibleWithTraitCollection:nil];
                }
            }
            else
            {
                //Failed to get the image data:
                cell.imageView.image = [UIImage imageNamed:@"imagePlaceholder"
                                                  inBundle:[NSBundle bundleForClass:self.class]
                             compatibleWithTraitCollection:nil];
            }
        });
    });
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_placeDetails.photos count] == 0 ? 1 : [_placeDetails.photos count];// >= 3 ? [_placeDetails.photos count] : 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *)indexPath {
    NSInteger count = [_placeDetails.photos count];
    double width = self.frame.size.width;
    return CGSizeMake(width, self.frame.size.height / 3);
 }

- (MWZUIBottomSheetComponents*) requireComponentForPlaceDetails:(MWZPlaceDetails*)placeDetails withDefaultComponents:(MWZUIBottomSheetComponents*)components {
    return components;
}

- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components {
    return components;
}


- (void) didTapOnDirectionButton {
    [_delegate didTapOnDirectionButton];
}

- (void) didTapOnInfoButton {
    [_delegate didTapOnInfoButton];
}

- (void) didTapOnCallButton {
    [_delegate didTapOnCallButton];
    NSURL *urlOption1 = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:_placeDetails.phone]];
    NSURL *urlOption2 = [NSURL URLWithString:[@"tel://" stringByAppendingString:_placeDetails.phone]];
    NSURL *targetURL = nil;
    if ([UIApplication.sharedApplication canOpenURL:urlOption1]) {
        targetURL = urlOption1;
    } else if ([UIApplication.sharedApplication canOpenURL:urlOption2]) {
        targetURL = urlOption2;
    }

    if (targetURL) {
        if (@available(iOS 10.0, *)) {
            [UIApplication.sharedApplication openURL:targetURL options:@{} completionHandler:nil];
        } else {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [UIApplication.sharedApplication openURL:targetURL];
    #pragma clang diagnostic pop
        }
    }
}
- (void) didTapOnShareButton {
    [_delegate didTapOnShareButton];
    NSArray *activityItems = @[_placeDetails.shareLink];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/4, 0, 0);
    }
    [self.window.rootViewController presentViewController:activityViewControntroller animated:true completion:nil];
}
- (void) didTapOnWebsiteButton {
    [_delegate didTapOnWebsiteButton];
    NSURL* url = [NSURL URLWithString:_placeDetails.website];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
       [[UIApplication sharedApplication] openURL:url];
    }
}

@end
