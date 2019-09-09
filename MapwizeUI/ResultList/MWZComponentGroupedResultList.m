#import "MWZComponentGroupedResultList.h"
#import "MWZComponentResultList.h"
#import "MWZComponentTitleCell.h"
#import "MWZComponentSubtitleCell.h"
#import "MWZComponentTitleWithoutFloorCellTableViewCell.h"
#import "MWZComponentGroupedResultListDelegate.h"

@interface MWZComponentGroupedResultList () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MWZComponentGroupedResultList {
    NSArray<MWZUniverse*>* accessibleUniverses;
    NSMutableArray<MWZUniverse*>* universes;
    MWZUniverse* activeUniverse;
    NSMutableDictionary<NSString*, NSMutableArray<id<MWZObject>>*>* contentByUniverseId;
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
        contentByUniverseId = [[NSMutableDictionary alloc] init];
        universes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setLanguage:(NSString*) language {
    self->language = language;
}

- (void) swapResults:(NSArray<id<MWZObject>>*) results universes:(NSArray<MWZUniverse*>*) universes activeUniverse:(MWZUniverse*) activeUniverse {
    [contentByUniverseId removeAllObjects];
    self->accessibleUniverses = universes;
    for (id<MWZObject> mapwizeObject in results) {
        NSArray<MWZUniverse*>* placeUniverses = mapwizeObject.universes;
        for (MWZUniverse* universe in placeUniverses) {
            NSMutableArray<id<MWZObject>>* objects = [contentByUniverseId objectForKey:universe.identifier];
            if (objects == nil) {
                objects = [[NSMutableArray alloc] init];
                [contentByUniverseId setObject:objects forKey:universe.identifier];
            }
            [objects addObject:mapwizeObject];
        }
    }
    self->universes = [[NSMutableArray alloc] init];
    for (MWZUniverse* u in accessibleUniverses) {
        for (NSString* identifier in contentByUniverseId.allKeys) {
            if ([u.identifier isEqualToString:identifier]) {
                [self->universes addObject:u];
            }
        }
    }
    self->activeUniverse = activeUniverse;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (universes.count > 0) {
        return universes.count;
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (universes.count > 1 || (universes.count == 1 && ![universes[0].identifier isEqualToString:activeUniverse.identifier])) {
        return universes[section].name;
        
    }
    return nil;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* imageVenue = [UIImage imageNamed:@"venue" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlace = [UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlacelist = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    imageVenue = [imageVenue imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlace = [imagePlace imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlacelist = [imagePlacelist imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    NSMutableArray<id<MWZObject>>* content;
    
    if (universes.count == 0) {
        MWZComponentTitleCell* cell = [self dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = NSLocalizedString(@"No results", "");
        [cell.imageView setImage:nil];
        return cell;
    }
    else {
        MWZUniverse* universe = universes[indexPath.section];
        content = contentByUniverseId[universe.identifier];
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
    
    if (universes.count > 0) {
        MWZUniverse* universe = universes[section];
        return contentByUniverseId[universe.identifier].count;
    }
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:NO];
    if (universes.count > 0) {
        MWZUniverse* universe = universes[indexPath.section];
        id<MWZObject> mapwizeObject = contentByUniverseId[universe.identifier][indexPath.row];
        if (_resultDelegate) {
            [_resultDelegate didSelect:mapwizeObject universe:universe];
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
