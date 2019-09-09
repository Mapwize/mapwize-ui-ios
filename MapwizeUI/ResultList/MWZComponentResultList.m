#import <MapwizeForMapbox/MapwizeForMapbox.h>
#import "MWZComponentResultList.h"
#import "MWZComponentTitleCell.h"
#import "MWZComponentSubtitleCell.h"
#import "MWZComponentTitleWithoutFloorCellTableViewCell.h"
#import "MWZComponentResultListDelegate.h"

@interface MWZComponentResultList () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MWZComponentResultList {
    NSMutableArray<id<MWZObject>>* content;
    NSLayoutConstraint* tableHeightConstraint;
    NSString* language;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        language = @"en";
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
        content = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setLanguage:(NSString*) language {
    self->language = language;
}

- (void) swapResults:(NSArray<id<MWZObject>>*) results {
    [content removeAllObjects];
    [content addObjectsFromArray:results];
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
    
    if (content.count == 0) {
        MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = NSLocalizedString(@"No results", "");
        [cell.imageView setImage:nil];
        return cell;
    }
    else {
        id<MWZObject> mapwizeObject = content[indexPath.row];
        if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
            MWZVenue* venue = (MWZVenue*) mapwizeObject;
            MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
            cell.titleView.text = [venue titleForLanguage:language];
            [cell.imageView setImage:imageVenue];
            return cell;
        }
        if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
            MWZPlace* place = (MWZPlace*) mapwizeObject;
            if ([place subtitleForLanguage:language] && [[place subtitleForLanguage:language] length] > 0) {
                MWZComponentSubtitleCell* cell = [self dequeueReusableCellWithIdentifier:@"subtitleCell"];
                cell.titleView.text = [place titleForLanguage:language];
                cell.subtitleView.text = [place subtitleForLanguage:language];
                cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
                [cell.imageView setImage:imagePlace];
                return cell;
            }
            else {
                MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleCell"];
                cell.titleView.text = [place titleForLanguage:language];
                cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
                [cell.imageView setImage:imagePlace];
                return cell;
            }
        }
        if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
            MWZPlacelist* placeList = (MWZPlacelist*) mapwizeObject;
            MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
            cell.titleView.text = [placeList titleForLanguage:language];
            [cell.imageView setImage:imagePlacelist];
            return cell;
        }
        MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (content.count >= 1) {
        return content.count;
    }
    else {
        return 1;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:NO];
    if (content.count > 0) {
        id<MWZObject> mapwizeObject = content[indexPath.row];
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
    if (tableHeightConstraint) {
        if (tableHeightConstraint.constant != self.contentSize.height) {
            tableHeightConstraint.constant = self.contentSize.height;
        }
        
    }
    else {
        tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:self.contentSize.height];
        tableHeightConstraint.priority = 200;
        [tableHeightConstraint setActive:YES];
    }
}

@end
