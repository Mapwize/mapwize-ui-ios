#import "MWZUIIssueTypeView.h"
#import "MWZUIBookingGridView.h"
#import "MWZUIIssueTypeCell.h"
#import "MWZUICollectionViewFlowLayout.h"



@implementation MWZUIIssueTypeView

- (instancetype) initWithFrame:(CGRect)frame issueTypes:(NSArray<MWZIssueType*>*)issueTypes color:(UIColor*)color language:(NSString*)language
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        self.type = MWZUIFullContentViewComponentRowCustom;
        _issueTypes = issueTypes;
        self.infoAvailable = YES;
        _language = language;
        [self setupView];
    }
    return self;
}

- (void) setupView {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    self.image = [UIImage imageNamed:@"issuetype" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    UILabel* issueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    issueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setTintColor:self.color];
    [issueLabel setText:NSLocalizedString(@"Issue type", @"")];
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    [self addSubview:issueLabel];
    [[issueLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:16] setActive:YES];
    [[issueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[issueLabel.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor constant:0.0] setActive:YES];
    
    MWZUICollectionViewFlowLayout* flowLayout = [[MWZUICollectionViewFlowLayout alloc] init];
    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsSelection = YES;
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self.collectionView registerClass:[MWZUIIssueTypeCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collectionView];
    
    [[self.collectionView.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:16.0] setActive:YES];
    [[self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
    [[self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0] setActive:YES];
    _collectionViewHeight = [_collectionView.heightAnchor constraintEqualToConstant:10];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionViewHeight setActive:YES];
    
    _errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _errorMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _errorMessageLabel.textColor = [UIColor redColor];
    [_errorMessageLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_errorMessageLabel];
    [[_errorMessageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[_errorMessageLabel.centerYAnchor constraintEqualToAnchor:issueLabel.centerYAnchor] setActive:YES];
    
}

- (void) setErrorMessage:(NSString*)message {
    [_errorMessageLabel setText:message];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _collectionViewHeight.constant = _collectionView.contentSize.height;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MWZUIIssueTypeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.color = self.color;
    cell.label.text = [_issueTypes[indexPath.row] titleForLanguage:_language];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _issueTypes.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate didSelectIssueType:_issueTypes[indexPath.row]];
}


@end
