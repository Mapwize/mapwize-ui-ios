#import "MWZMapViewController.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"
#import "MWZDirectionScene.h"
#import "ILIndoorLocation+DirectionPoint.h"
#import "MWZDefaultSceneProperties.h"
#import "MWZComponentFloorController.h"

typedef NS_ENUM(NSUInteger, MWZViewState) {
    MWZViewStateDefault,
    MWZViewStateDirectionOff,
    MWZViewStateDirectionOn,
    MWZViewStateSearchVenues,
    MWZViewStateSearchInVenue,
    MWZViewStateSearchDirectionFrom,
    MWZViewStateSearchDirectionTo
};

@interface MWZMapViewController ()

@property (nonatomic) MWZOptions* options;

@property (nonatomic) MWZComponentFloorController* floorController;

@property (nonatomic) MWZSceneCoordinator* sceneCoordinator;
@property (nonatomic) MWZSearchScene* searchScene;
@property (nonatomic) MWZDefaultScene* defaultScene;
@property (nonatomic) MWZDirectionScene* directionScene;

@property (nonatomic) NSArray<MWZVenue*>* mainVenues;
@property (nonatomic) NSArray<id<MWZObject>>* mainSearches;
@property (nonatomic) NSArray<MWZPlace*>* mainFroms;
@property (nonatomic) id<MWZObject> selectedContent;

@property (nonatomic) id<MWZDirectionPoint> fromDirectionPoint;
@property (nonatomic) id<MWZDirectionPoint> toDirectionPoint;
@property (nonatomic, assign) BOOL isAccessible;

@property (nonatomic, assign) MWZViewState state;

@end

@implementation MWZMapViewController

-(instancetype) initWithOptions:(MWZOptions*) options {
    self = [super init];
    if (self) {
        self.options = options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = [[MWZOptions alloc] init];
    [self initializeWithOptions:self.options];
    [self fetchDefaultVenueSearch];
}

- (void) initializeWithOptions:(MWZOptions*) options {
    self.mapView = [[MWZMapView alloc] initWithFrame:self.view.frame options:options];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.mapView];

    self.sceneCoordinator = [[MWZSceneCoordinator alloc] initWithContainerView:self.view];
    
    self.defaultScene = [[MWZDefaultScene alloc] initWith:self.options.mainColor];
    self.defaultScene.delegate = self;
    self.sceneCoordinator.defaultScene = self.defaultScene;
    
    self.searchScene = [[MWZSearchScene alloc] initWith:self.options.mainColor];
    self.searchScene.delegate = self;
    self.sceneCoordinator.searchScene = self.searchScene;
    
    self.directionScene = [[MWZDirectionScene alloc] initWith:self.options.mainColor];
    self.directionScene.delegate = self;
    self.sceneCoordinator.directionScene = self.directionScene;
    
    [self addFloorController];
}

- (void) addFloorController {
    self.floorController = [[MWZComponentFloorController alloc] initWithColor:self.options.mainColor];
    self.floorController.translatesAutoresizingMaskIntoConstraints = NO;
    self.floorController.floorControllerDelegate = self;
    [self.view addSubview:self.floorController];
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:96.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeTrailing
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeTrailing
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    /*if (uiSettings.compassIsHidden) {
        NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:self.floorController
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.searchBar
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0f
                                                                                  constant:8.0f];
        toSearchBarConstraint.priority = 999;
        [toSearchBarConstraint setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:self.floorController
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:self.directionBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    else {
        [[NSLayoutConstraint constraintWithItem:self.floorController
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:self.compassView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }*/
}

#pragma mark Search initialization
- (void) fetchDefaultVenueSearch {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.query = @"";
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    params.venueId = self.mapView.mapOptions.restrictContentToVenueId;
    params.objectClass = @[@"venue"];
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        self.mainVenues = searchResponse;
    } failure:^(NSError *error) {
        self.mainVenues = @[];
    }];
}

- (void) fetchMainSearchesForVenues:(MWZVenue*) venue {
    [self.mapView.mapwizeApi getMainSearchesWithVenue:venue success:^(NSArray<id<MWZObject>> *mainSearches) {
        self.mainSearches = mainSearches;
    } failure:^(NSError *error) {
        self.mainSearches = @[];
    }];
    [self.mapView.mapwizeApi getMainFromsWithVenue:venue success:^(NSArray<MWZPlace *> *mainFroms) {
        self.mainFroms = mainFroms;
    } failure:^(NSError *error) {
        self.mainFroms = @[];
    }];
}

#pragma mark Scene transitions
- (void) mapToSearchTransition {
    if ([_mapView getVenue]) {
        self.state = MWZViewStateSearchInVenue;
    }
    else {
        self.state = MWZViewStateSearchVenues;
    }
    [self.sceneCoordinator transitionFromDefaultToSearch];
}

- (void) searchToMapTransition {
    self.state = MWZViewStateDefault;
    [self.sceneCoordinator transitionFromSearchToDefault];
}

- (void) defaultToDirectionTransition {
    self.state = MWZViewStateDirectionOff;
    [self setFromDirectionPoint:[self.mapView getUserLocation]];
    [self setToDirectionPoint:(id<MWZDirectionPoint>)self.selectedContent];
    [self setIsAccessible:self.isAccessible];
    [self.sceneCoordinator transitionFromDefaultToDirection];
    if (self.fromDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainFroms withLanguage:[self.mapView getLanguage]];
    }
    else if (self.toDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
    }
    else {
        [self startDirection];
    }
}

- (void) directionToDefaultTransition {
    self.state = MWZViewStateDefault;
    [self.directionScene setDirectionInfoHidden:YES];
    [self.sceneCoordinator transitionFromDirectionToDefault];
}

- (void) directionToSearchFromTransition {
    self.state = MWZViewStateSearchDirectionFrom;
    [self.sceneCoordinator transitionFromDirectionToSearch];
}

- (void) directionToSearchToTransition {
    self.state = MWZViewStateSearchDirectionTo;
    [self.sceneCoordinator transitionFromDirectionToSearch];
}

- (void) searchToDirectionTransition {
    self.state = MWZViewStateDirectionOff;
    [self.sceneCoordinator transitionFromSearchToDirection];
}

#pragma mark Content selection
- (void) showSelectedContent {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.language = [self.mapView getLanguage];
    defaultProperties.infoButtonHidden = NO;
    [self.defaultScene setSceneProperties:defaultProperties];
    if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
        [self.mapView addMarkerOnPlace:(MWZPlace*)self.selectedContent];
        [self.mapView addPromotedPlace:(MWZPlace*)self.selectedContent];
    }
}

- (void) unselectContent {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = nil;
    [self.defaultScene setSceneProperties:defaultProperties];
    [self.mapView removeMarkers];
    [self.mapView removePromotedPlaces];
    self.selectedContent = nil;
}

- (void) selectPlace:(MWZPlace*) place {
    if (self.selectedContent) {
        [self.mapView removeMarkers];
        [self.mapView removePromotedPlaces];
    }
    [self.mapView addMarkerOnPlace:place];
    [self.mapView addPromotedPlace:place];
    self.selectedContent = place;
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.language = [self.mapView getLanguage];
    defaultProperties.infoButtonHidden = NO;
    [self.defaultScene setSceneProperties:defaultProperties];
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview {
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self selectPlace:place];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark Direction methods
- (void) setFromDirectionPoint:(id<MWZDirectionPoint>)fromDirectionPoint {
    _fromDirectionPoint = fromDirectionPoint;
    if (fromDirectionPoint == nil) {
        [self.directionScene setFromText:NSLocalizedString(@"Starting point",@"") asPlaceHolder:YES];
    }
    else if ([fromDirectionPoint isKindOfClass:MWZPlace.class]) {
        [self.directionScene setFromText:[(MWZPlace*)fromDirectionPoint titleForLanguage:[self.mapView getLanguage]] asPlaceHolder:NO];
    }
    else if ([fromDirectionPoint isKindOfClass:MWZPlacelist.class]) {
        [self.directionScene setFromText:[(MWZPlacelist*)fromDirectionPoint titleForLanguage:[self.mapView getLanguage]] asPlaceHolder:NO];
    }
    else if ([fromDirectionPoint isKindOfClass:ILIndoorLocation.class]) {
        [self.directionScene setFromText:NSLocalizedString(@"Current location", @"") asPlaceHolder:NO];
    }
    if (self.state == MWZViewStateSearchDirectionFrom) {
        [self.directionScene closeFromSearch];
        if (self.toDirectionPoint == nil) {
            self.state = MWZViewStateSearchDirectionTo;
            [self.directionScene openToSearch];
            [self.directionScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
        }
        else {
            [self.directionScene setSearchResultsHidden:YES];
        }
    }
    if ([self shouldStartDirection]) {
        [self startDirection];
    }
}

- (void) setToDirectionPoint:(id<MWZDirectionPoint>)toDirectionPoint {
    _toDirectionPoint = toDirectionPoint;
    if (toDirectionPoint == nil) {
        [self.directionScene setToText:NSLocalizedString(@"Destination",@"") asPlaceHolder:YES];
    }
    else if ([toDirectionPoint isKindOfClass:MWZPlace.class]) {
        [self.directionScene setToText:[(MWZPlace*)toDirectionPoint titleForLanguage:[self.mapView getLanguage]] asPlaceHolder:NO];
    }
    else if ([toDirectionPoint isKindOfClass:MWZPlacelist.class]) {
        [self.directionScene setToText:[(MWZPlacelist*)toDirectionPoint titleForLanguage:[self.mapView getLanguage]] asPlaceHolder:NO];
    }
    else if ([toDirectionPoint isKindOfClass:ILIndoorLocation.class]) {
        [self.directionScene setToText:NSLocalizedString(@"Current location", @"") asPlaceHolder:NO];
    }
    [self.directionScene closeToSearch];
    [self.directionScene setSearchResultsHidden:YES];
    if ([self shouldStartDirection]) {
        [self startDirection];
    }
}

-(void) setIsAccessible:(BOOL)isAccessible {
    _isAccessible = isAccessible;
    [self.directionScene setAccessibleMode:isAccessible];
    if ([self shouldStartDirection]) {
        [self startDirection];
    }
}

-(BOOL) shouldStartDirection {
    return (self.state == MWZViewStateDirectionOn
            || self.state == MWZViewStateDirectionOff
            || self.state == MWZViewStateSearchDirectionFrom
            || self.state == MWZViewStateSearchDirectionTo)
            && self.fromDirectionPoint && self.toDirectionPoint;
}

- (void) startDirection {
    if ([self.fromDirectionPoint isKindOfClass:ILIndoorLocation.class]) {
        MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
        [self.mapView startNavigation:self.toDirectionPoint isAccessible:self.isAccessible options:options];
    }
    [self.mapView.mapwizeApi getDirectionWithFrom:self.fromDirectionPoint
                                               to:self.toDirectionPoint
                                     isAccessible:self.isAccessible success:^(MWZDirection * _Nonnull direction) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.state = MWZViewStateDirectionOn;
            [self.mapView setDirection:direction];
            [self.directionScene setInfoWith:direction.traveltime
                           directionDistance:direction.distance
                                isAccessible:self.isAccessible];
            [self.directionScene setDirectionInfoHidden:NO];
        });
    } failure:^(NSError * _Nonnull error) {
        // TODO HANDLE DIRECTION NOT FOUND
    }];
}

#pragma mark MWZMapViewDelegate
- (void)mapView:(MWZMapView *_Nonnull)mapView didTap:(MWZClickEvent *_Nonnull)clickEvent {
    if (self.state != MWZViewStateDefault) {
        return;
    }
    switch (clickEvent.eventType) {
        case MWZClickEventTypeVenueClick:
            [self.mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
            break;
        case MWZClickEventTypePlaceClick:
            [self selectPlacePreview:clickEvent.placePreview];
            break;
        default:
            [self unselectContent];
            break;
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueWillEnter:(MWZVenue *_Nonnull)venue {
    [self fetchMainSearchesForVenues:venue];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidEnter:(MWZVenue *_Nonnull)venue {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = venue;
    [self.defaultScene setSceneProperties:defaultProperties];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidExit:(MWZVenue *_Nonnull)venue {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = nil;
    [self.defaultScene setSceneProperties:defaultProperties];
    self.mainSearches = @[];
}

- (void)mapView:(MWZMapView *)mapView floorsDidChange:(NSArray<MWZFloor *> *)floors {
    [self.floorController mapwizeFloorsDidChange:floors showController:YES];
}

- (void)mapView:(MWZMapView *)mapView floorDidChange:(MWZFloor*)floor {
    [self.floorController mapwizeFloorDidChange:floor];
}

- (void)mapView:(MWZMapView *)mapView floorWillChange:(MWZFloor*)floor {
    [self.floorController mapwizeFloorWillChange:floor];
}

#pragma mark MWZComponentFloorControllerDelegate
- (void) floorController:(MWZComponentFloorController*) floorController didSelect:(NSNumber*) floorOrder {
    [self.mapView setFloor:floorOrder];
}


#pragma mark MWZDefaultSceneDelegate
- (void) didTapOnSearchButton {
    if ([self.mapView getVenue]) {
       [self.searchScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
    }
    else {
        [self.searchScene showSearchResults:self.mainVenues withLanguage:[self.mapView getLanguage]];
    }
    [self mapToSearchTransition];
}

- (void) didTapOnMenuButton {
    
}

- (void) didTapOnDirectionButton {
    [self defaultToDirectionTransition];
}

#pragma mark MWZSearchSceneDelegate
- (void)didTapOnBackButton {
    if (self.state == MWZViewStateSearchVenues || self.state == MWZViewStateSearchInVenue) {
        [self searchToMapTransition];
    }
    else if (self.state == MWZViewStateSearchDirectionFrom) {
        [self searchToDirectionTransition];
    }
    else if (self.state == MWZViewStateSearchDirectionTo) {
        [self searchToDirectionTransition];
    }
}

- (void)searchQueryDidChange:(NSString *)query {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    
    if (self.state == MWZViewStateSearchVenues) {
        params.objectClass = @[@"venue"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainVenues withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    if (self.state == MWZViewStateSearchInVenue || self.state == MWZViewStateSearchDirectionTo) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place", @"placeList"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    if (self.state == MWZViewStateSearchDirectionFrom) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainFroms withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    
    params.query = query;
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchScene showSearchResults:searchResponse withLanguage:[self.mapView getLanguage]];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)didSelect:(id<MWZObject>)mapwizeObject {
    if (self.state == MWZViewStateSearchVenues) {
        [self.mapView centerOnVenue:(MWZVenue*)mapwizeObject animated:YES];
        [self searchToMapTransition];
    }
    else if (self.state == MWZViewStateSearchInVenue) {
        if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
            [self.mapView centerOnPlace:(MWZPlace*)mapwizeObject animated:YES];
            [self selectPlace:(MWZPlace*)mapwizeObject];
        }
        if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
            
        }
        [self searchToMapTransition];
    }
    else if (self.state == MWZViewStateSearchDirectionFrom) {
        [self setFromDirectionPoint:(id<MWZDirectionPoint>)mapwizeObject];
        
    }
    else if (self.state == MWZViewStateSearchDirectionTo) {
        [self setToDirectionPoint:(id<MWZDirectionPoint>)mapwizeObject];
        
    }
}

#pragma mark MWZDirectionSceneDelegate
- (void)directionSceneDidTapOnBackButton:(MWZDirectionScene *)scene {
    if (self.state == MWZViewStateSearchDirectionFrom || self.state == MWZViewStateSearchDirectionTo) {
        [self.directionScene closeFromSearch];
        [self.directionScene closeToSearch];
        [self.directionScene setSearchResultsHidden:YES];
        if ([self.mapView getDirection]) {
            self.state = MWZViewStateDirectionOn;
        }
        else {
            [self directionToDefaultTransition];
        }
    }
    else if (self.state == MWZViewStateDirectionOn) {
        [self.mapView removeDirection];
        [self directionToDefaultTransition];
    }
    else if (self.state == MWZViewStateDirectionOff) {
        [self directionToDefaultTransition];
    }
}

- (void)directionSceneDidTapOnFromButton:(MWZDirectionScene *)scene {
    if ([self.mapView getVenue]) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        [self.directionScene closeToSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainFroms withLanguage:[self.mapView getLanguage]];
    }
}

- (void)directionSceneDidTapOnToButton:(MWZDirectionScene *)scene {
    if ([self.mapView getVenue] && self.fromDirectionPoint) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene closeFromSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
    }
}

- (void) directionSceneDidTapOnSwapButton:(id)directionHeader {
    id tmpFrom = self.toDirectionPoint;
    id tmpTo = self.fromDirectionPoint;
    self.toDirectionPoint = nil;
    self.fromDirectionPoint = nil;
    [self setFromDirectionPoint:tmpFrom];
    [self setToDirectionPoint:tmpTo];
}

-(void)directionSceneAccessibilityModeDidChange:(BOOL)isAccessible {
    [self setIsAccessible:isAccessible];
    
}

- (void) searchDirectionQueryDidChange:(NSString*) query {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    
    if (self.state == MWZViewStateSearchDirectionTo) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place", @"placeList"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainSearches withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    if (self.state == MWZViewStateSearchDirectionFrom) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainFroms withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    
    params.query = query;
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.directionScene showSearchResults:searchResponse withLanguage:[self.mapView getLanguage]];
        });
    } failure:^(NSError *error) {
        
    }];
}



@end
