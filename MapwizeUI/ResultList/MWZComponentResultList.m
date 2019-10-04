#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZComponentResultList.h"
#import "MWZComponentTitleCell.h"
#import "MWZComponentSubtitleCell.h"
#import "MWZComponentTitleWithoutFloorCellTableViewCell.h"
#import "MWZComponentResultListDelegate.h"

@interface MWZComponentResultList () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray<id<MWZObject>>* content;
@property (nonatomic) NSLayoutConstraint* tableHeightConstraint;
@property (nonatomic) NSString* language;

@end

@implementation MWZComponentResultList

- (instancetype)init {
    self = [super init];
    if (self) {
        _language = @"en";
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.rowHeight = UITableViewAutomaticDimension;
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
        [self registerClass:[MWZComponentTitleWithoutFloorCellTableViewCell class] forCellReuseIdentifier:@"titleWithoutFloorCell"];
        [self registerClass:[MWZComponentTitleCell class] forCellReuseIdentifier:@"titleCell"];
        [self registerClass:[MWZComponentSubtitleCell class] forCellReuseIdentifier:@"subtitleCell"];
        _content = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setLanguage:(NSString*) language {
    _language = language;
}

- (void) swapResults:(NSArray<id<MWZObject>>*) results {
    [self.content removeAllObjects];
    [self.content addObjectsFromArray:results];
    [self reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* imageVenue = [UIImage imageNamed:@"venue" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlace = [UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlacelist = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    imageVenue = [imageVenue imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlace = [imagePlace imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlacelist = [imagePlacelist imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (self.content.count == 0) {
        MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = NSLocalizedString(@"No results", "");
        [cell.imageView setImage:nil];
        return cell;
    }
    else {
        id<MWZObject> mapwizeObject = self.content[indexPath.row];
        if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
            MWZVenue* venue = (MWZVenue*) mapwizeObject;
            MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
            cell.titleView.text = [venue titleForLanguage:self.language];
            [cell.imageView setImage:imageVenue];
            return cell;
        }
        if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
            MWZPlace* place = (MWZPlace*) mapwizeObject;
            if ([place subtitleForLanguage:self.language] && [[place subtitleForLanguage:self.language] length] > 0) {
                MWZComponentSubtitleCell* cell = [self dequeueReusableCellWithIdentifier:@"subtitleCell"];
                cell.titleView.text = [place titleForLanguage:self.language];
                cell.subtitleView.text = [place subtitleForLanguage:self.language];
                cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
                [cell.imageView setImage:imagePlace];
                return cell;
            }
            else {
                MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleCell"];
                cell.titleView.text = [place titleForLanguage:self.language];
                cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
                [cell.imageView setImage:imagePlace];
                return cell;
            }
        }
        if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
            MWZPlacelist* placeList = (MWZPlacelist*) mapwizeObject;
            MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
            cell.titleView.text = [placeList titleForLanguage:self.language];
            [cell.imageView setImage:imagePlacelist];
            return cell;
        }
        MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.content.count >= 1) {
        return self.content.count;
    }
    else {
        return 1;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:NO];
    if (self.content.count > 0) {
        id<MWZObject> mapwizeObject = self.content[indexPath.row];
        if (_resultDelegate) {
            [_resultDelegate didSelect:mapwizeObject];
        }
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateHeight];
    }
}

- (void) updateHeight {
    [self.layer removeAllAnimations];
    if (self.tableHeightConstraint) {
        if (self.tableHeightConstraint.constant != self.contentSize.height) {
            self.tableHeightConstraint.constant = self.contentSize.height;
        }
        
    }
    else {
        self.tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:self.contentSize.height];
        self.tableHeightConstraint.priority = 200;
        [self.tableHeightConstraint setActive:YES];
    }
}

@end
