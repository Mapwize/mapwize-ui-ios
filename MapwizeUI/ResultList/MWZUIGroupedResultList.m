#import "MWZUIGroupedResultList.h"
#import "MWZUITitleCell.h"
#import "MWZUISubtitleCell.h"
#import "MWZUITitleWithoutFloorCellTableViewCell.h"
#import "MWZUIGroupedResultListDelegate.h"

@interface MWZUIGroupedResultList () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSArray<MWZUniverse*>* accessibleUniverses;
@property (nonatomic) NSMutableArray<MWZUniverse*>* universes;
@property (nonatomic) MWZUniverse* activeUniverse;
@property (nonatomic) NSMutableArray<id<MWZObject>>* ungroupedResults;
@property (nonatomic) NSMutableDictionary<NSString*, NSMutableArray<id<MWZObject>>*>* contentByUniverseId;
@property (nonatomic) NSLayoutConstraint* tableHeightConstraint;
@property (nonatomic) NSString* language;
@property (nonatomic) NSString* query;
@property (nonatomic) BOOL networkError;

@end

@implementation MWZUIGroupedResultList

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
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.tableView];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [[self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
        [[self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView registerClass:[MWZUITitleWithoutFloorCellTableViewCell class] forCellReuseIdentifier:@"titleWithoutFloorCell"];
        [self.tableView registerClass:[MWZUITitleCell class] forCellReuseIdentifier:@"titleCell"];
        [self.tableView registerClass:[MWZUISubtitleCell class] forCellReuseIdentifier:@"subtitleCell"];
        _contentByUniverseId = [[NSMutableDictionary alloc] init];
        _ungroupedResults = [[NSMutableArray alloc] init];
        _universes = [[NSMutableArray alloc] init];
        
        self.tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:0];
        self.tableHeightConstraint.priority = 200;
        [self.tableHeightConstraint setActive:YES];
    }
    return self;
}

- (void) setLanguage:(NSString*) language {
    _language = language;
}

- (void) swapResults:(NSArray<id<MWZObject>>*) results
           universes:(NSArray<MWZUniverse*>*) universes
      activeUniverse:(MWZUniverse*) activeUniverse
            language:(nonnull NSString *)language
            forQuery:(NSString*) query {
    _networkError = NO;
    _query = query;
    [self setLanguage:language];
    [self.contentByUniverseId removeAllObjects];
    [self.ungroupedResults removeAllObjects];
    if (universes.count > 0) {
        self.accessibleUniverses = universes;
        self.activeUniverse = activeUniverse;
        [self buildResultsMap:results universes:universes activeUniverse:activeUniverse];
        [self buildUniversesArray];
    }
    [self.tableView reloadData];
}

- (void) setNetworkError:(BOOL)networkError {
    _networkError = networkError;
    [self.tableView reloadData];
}

- (void) swapResults:(NSArray<id<MWZObject>> *)results language:(NSString *)language forQuery:(NSString*) query {
    _query = query;
    [self setLanguage:language];
    [self.contentByUniverseId removeAllObjects];
    self.universes = nil;
    self.accessibleUniverses = nil;
    self.activeUniverse = nil;
    [self.ungroupedResults removeAllObjects];
    [self.ungroupedResults addObjectsFromArray:results];
    [self.tableView reloadData];
}

- (void) buildResultsMap:(NSArray<id<MWZObject>>*) results
               universes:(NSArray<MWZUniverse*>*) universes
          activeUniverse:(MWZUniverse*) activeUniverse {
    for (id<MWZObject> mapwizeObject in results) {
        NSArray<MWZUniverse*>* placeUniverses = mapwizeObject.universes;
        for (MWZUniverse* universe in placeUniverses) {
            NSMutableArray<id<MWZObject>>* objects = [self.contentByUniverseId objectForKey:universe.identifier];
            if (objects == nil) {
                objects = [[NSMutableArray alloc] init];
                [self.contentByUniverseId setObject:objects forKey:universe.identifier];
            }
            [objects addObject:mapwizeObject];
        }
    }
}

- (void) buildUniversesArray {
    self.universes = [[NSMutableArray alloc] init];
    for (MWZUniverse* u in self.accessibleUniverses) {
        for (NSString* identifier in self.contentByUniverseId.allKeys) {
            if ([u.identifier isEqualToString:identifier]) {
                if ([u.identifier isEqualToString:self.activeUniverse.identifier]) {
                    [self.universes insertObject:u atIndex:0];
                }
                else {
                    [self.universes addObject:u];
                }
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.universes && self.universes.count > 0) {
        return self.universes.count;
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.universes && self.universes.count >= 1 && ![self.universes[section].identifier isEqualToString:self.activeUniverse.identifier]) {
        return self.universes[section].name;
    }
    return nil;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSMutableArray<id<MWZObject>>* content;
    
    if (self.networkError) {
        MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = NSLocalizedString(@"Search error", "");
        [cell.imageView setImage:nil];
        return cell;
    }
    else if (self.ungroupedResults.count > 0) {
        id<MWZObject> mapwizeObject = self.ungroupedResults[indexPath.row];
        return [self getCellFor:mapwizeObject];
    }
    else if (!self.universes || self.universes.count == 0) {
        MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = NSLocalizedString(@"No results", "");
        [cell.imageView setImage:nil];
        return cell;
    }
    else {
        MWZUniverse* universe = self.universes[indexPath.section];
        content = self.contentByUniverseId[universe.identifier];
        id<MWZObject> mapwizeObject = content[indexPath.row];
        return [self getCellFor:mapwizeObject];
    }
}

- (UITableViewCell*) getCellFor:(id<MWZObject>) mapwizeObject {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* imageVenue = [UIImage imageNamed:@"venue" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlace = [UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage* imagePlacelist = [UIImage imageNamed:@"search_menu" inBundle:bundle compatibleWithTraitCollection:nil];
    imageVenue = [imageVenue imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlace = [imagePlace imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imagePlacelist = [imagePlacelist imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
        MWZVenue* venue = (MWZVenue*) mapwizeObject;
        MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = [venue titleForLanguage:self.language];
        [cell.imageView setImage:imageVenue];
        return cell;
    }
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        MWZPlace* place = (MWZPlace*) mapwizeObject;
        if ([place subtitleForLanguage:self.language] && [[place subtitleForLanguage:self.language] length] > 0) {
            MWZUISubtitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"subtitleCell"];
            cell.titleView.text = [place titleForLanguage:self.language];
            cell.subtitleView.text = [place subtitleForLanguage:self.language];
            cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
            [cell.imageView setImage:imagePlace];
            return cell;
        }
        else {
            MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            cell.titleView.text = [place titleForLanguage:self.language];
            cell.floorView.text = [NSString stringWithFormat:NSLocalizedString(@"Floor %@", ""), place.floor];
            [cell.imageView setImage:imagePlace];
            return cell;
        }
    }
    if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
        MWZPlacelist* placeList = (MWZPlacelist*) mapwizeObject;
        MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
        cell.titleView.text = [placeList titleForLanguage:self.language];
        [cell.imageView setImage:imagePlacelist];
        return cell;
    }
    MWZUITitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleWithoutFloorCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_networkError) {
        return 1;
    }
    if (self.universes && self.universes.count > 0) {
        MWZUniverse* universe = self.universes[section];
        return self.contentByUniverseId[universe.identifier].count;
    }
    if (self.ungroupedResults.count > 0) {
        return self.ungroupedResults.count;
    }
    if ([self.query length] == 0) {
        return 0;
    }
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.universes && self.universes.count > 0) {
        MWZUniverse* universe = self.universes[indexPath.section];
        id<MWZObject> mapwizeObject = self.contentByUniverseId[universe.identifier][indexPath.row];
        if (_resultDelegate) {
            [_resultDelegate didSelect:mapwizeObject universe:universe forQuery:_query];
        }
    }
    else if (self.ungroupedResults.count > 0) {
        id<MWZObject> mapwizeObject = self.ungroupedResults[indexPath.row];
        if (_resultDelegate) {
            [_resultDelegate didSelect:mapwizeObject universe:nil forQuery:_query];
        }
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateHeight];
    }
}

- (void) updateHeight {
    if (self.tableHeightConstraint.constant != self.tableView.contentSize.height) {
        self.tableHeightConstraint.constant = self.tableView.contentSize.height;
    }
}

@end
