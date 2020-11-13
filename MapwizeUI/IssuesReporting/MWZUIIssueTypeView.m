#import "MWZUIIssueTypeView.h"
#import "MWZUIBookingGridView.h"
#import "MWZUIIssueTypeCell.h"
#import "MWZUICollectionViewFlowFlowLayout.h"

@implementation MWZUIIssueTypeView

- (instancetype) initWithFrame:(CGRect)frame issueTypes:(NSArray<NSString*>*)issueTypes color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        self.type = MWZUIFullContentViewComponentRowCustom;
        self.issueTypes = issueTypes;
        self.infoAvailable = YES;
        [self setupView];
    }
    return self;
}

- (void) setupView {
    self.image = [UIImage systemImageNamed:@"ant.fill"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    UILabel* issueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    issueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setTintColor:self.color];
    [issueLabel setFont:[UIFont systemFontOfSize:14]];
    [issueLabel setText:@"Issue types"];
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    [self addSubview:issueLabel];
    [[issueLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:32] setActive:YES];
    [[issueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[issueLabel.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor constant:0.0] setActive:YES];
    
    MWZUICollectionViewFlowFlowLayout* flowLayout = [[MWZUICollectionViewFlowFlowLayout alloc] init];
    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    //flowLayout.minimumInteritemSpacing = 40;
    //flowLayout.minimumLineSpacing = 2;
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
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _collectionViewHeight.constant = _collectionView.contentSize.height;
    NSLog(@"Height %f", _collectionView.contentSize.height);
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MWZUIIssueTypeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.color = self.color;
    cell.label.text = _issueTypes[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _issueTypes.count;
}


@end
