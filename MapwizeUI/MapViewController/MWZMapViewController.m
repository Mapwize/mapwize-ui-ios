#import "MWZMapViewController.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"
#import "MWZDirectionScene.h"
#import "ILIndoorLocation+DirectionPoint.h"
#import "MWZDefaultSceneProperties.h"
#import "MWZComponentFloorController.h"
#import "MWZComponentFollowUserButton.h"
#import "MWZComponentCompass.h"
#import "MWZComponentUniversesButton.h"
#import "MWZComponentLanguagesButton.h"

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

@property (nonatomic) MWZUIOptions* options;
@property (nonatomic) MWZMapwizeViewUISettings* settings;

@property (nonatomic) MWZComponentFloorController* floorController;
@property (nonatomic) MWZComponentFollowUserButton* followUserButton;
@property (nonatomic) MWZComponentCompass* compassView;
@property (nonatomic) MWZComponentUniversesButton* universesButton;
@property (nonatomic) MWZComponentLanguagesButton* languagesButton;

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

@property (nonatomic) NSLayoutConstraint* universesButtonLeftConstraint;

@end

@implementation MWZMapViewController

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options;
        _settings = uiSettings;
        [self initializeWithOptions:options mapwizeConfiguration:[MWZMapwizeConfiguration sharedInstance]];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        _settings = uiSettings;
        [self initializeWithOptions:options mapwizeConfiguration:mapwizeConfiguration];
    }
    return self;
}

- (void) initializeWithOptions:(MWZUIOptions*) options
          mapwizeConfiguration:(MWZMapwizeConfiguration*) configuration {
    self.mapView = [[MWZMapView alloc] initWithFrame:self.frame options:options mapwizeConfiguration:configuration];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.mapView.mapboxDelegate = self;
    [self addSubview:self.mapView];
    
    [self addFloorController];
    [self addCompassView];
    [self addFollowUserButton];
    [self addLanguagesButton];
    [self addUniversesButton];
    self.sceneCoordinator = [[MWZSceneCoordinator alloc] initWithContainerView:self];
    
    self.defaultScene = [[MWZDefaultScene alloc] initWith:self.options.mainColor];
    self.defaultScene.delegate = self;
    self.sceneCoordinator.defaultScene = self.defaultScene;
    
    self.searchScene = [[MWZSearchScene alloc] initWith:self.options.mainColor];
    self.searchScene.delegate = self;
    self.sceneCoordinator.searchScene = self.searchScene;
    
    self.directionScene = [[MWZDirectionScene alloc] initWith:self.options.mainColor];
    self.directionScene.delegate = self;
    self.sceneCoordinator.directionScene = self.directionScene;
    
    [self applyFloorControllerConstraint];
    [self applyCompassConstraints];
    [self applyFollowUserButtonConstraints];
    [self applyLanguagesButtonConstraints];
    [self applyUniversesButtonConstraints];
    
    [self fetchDefaultVenueSearch];
    
    if (options.centerOnLocation) {
        [self.mapView.mapboxMapView setCenterCoordinate:options.centerOnLocation.coordinates
                                              zoomLevel:18.0 animated:NO];
        [self.mapView setFloor:options.centerOnLocation.floor];
    }
    
    if (options.centerOnPlaceId) {
        [self.mapView.mapwizeApi getPlaceWithIdentifier:options.centerOnPlaceId success:^(MWZPlace * _Nonnull place) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self selectPlace:place];
            });
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void) addLanguagesButton {
    self.languagesButton = [[MWZComponentLanguagesButton alloc] init];
    self.languagesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.languagesButton.delegate = self;
    [self addSubview:self.languagesButton];
}

- (void) applyLanguagesButtonConstraints {
    NSLayoutConstraint* languagesButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1.0f
                                                                                        constant:50.f];
    
    NSLayoutConstraint* languagesButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                                      attribute:NSLayoutAttributeWidth
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:nil
                                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                                     multiplier:1.0f
                                                                                       constant:50.f];
    
    NSLayoutConstraint* languagesButtonMinY = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0f
                                                                            constant:0.0f];
    languagesButtonMinY.priority = 950;
    languagesButtonMinY.active = YES;
    
    NSLayoutConstraint* languagesButtonRightConstraint;
    NSLayoutConstraint* languagesButtonBottomConstraint;
    if (@available(iOS 11.0, *)) {
        languagesButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:self.safeAreaInsets.left + 16.0f];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant: -32.0f];
    }
    else {
        languagesButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:16.0f];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-32.0f];
    }
    
    languagesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.languagesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:[self.directionScene getBottomViewToConstraint]
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* languagesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:[self.defaultScene getBottomViewToConstraint]
                                                                                       attribute:NSLayoutAttributeTop
                                                                                      multiplier:1.0f
                                                                                        constant:-16.0f];
    languagesToBottomViewConstraint.priority = 800;
    [languagesToBottomViewConstraint setActive:YES];
    
    [languagesButtonHeightConstraint setActive:YES];
    [languagesButtonWidthConstraint setActive:YES];
    [languagesButtonRightConstraint setActive:YES];
    [languagesButtonBottomConstraint setActive:YES];
}

- (void) addUniversesButton {
    self.universesButton = [[MWZComponentUniversesButton alloc] init];
    self.universesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.universesButton.delegate = self;
    [self addSubview:self.universesButton];
}

- (void) applyUniversesButtonConstraints {
    NSLayoutConstraint* universesButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1.0f
                                                                                        constant:50.f];
    
    NSLayoutConstraint* universesButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                                      attribute:NSLayoutAttributeWidth
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:nil
                                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                                     multiplier:1.0f
                                                                                       constant:50.f];
    
    NSLayoutConstraint* universeButtonMinY = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0f
                                                                           constant:0.0f];
    universeButtonMinY.priority = 950;
    universeButtonMinY.active = YES;
    
    NSLayoutConstraint* universesButtonBottomConstraint;
    if (@available(iOS 11.0, *)) {
        self.universesButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f
                                                                           constant:16.0f * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-32.0f];
    }
    else {
        self.universesButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f
                                                                           constant:16.0f * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-32.0f];
    }
    
    universesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.universesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:[self.directionScene getBottomViewToConstraint]
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* universesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:[self.defaultScene getBottomViewToConstraint]
                                                                                       attribute:NSLayoutAttributeTop
                                                                                      multiplier:1.0f
                                                                                        constant:-16.0f];
    universesToBottomViewConstraint.priority = 800;
    [universesToBottomViewConstraint setActive:YES];
    
    [universesButtonHeightConstraint setActive:YES];
    [universesButtonWidthConstraint setActive:YES];
    [self.universesButtonLeftConstraint setActive:YES];
    [universesButtonBottomConstraint setActive:YES];
}

- (void) addFollowUserButton {
    self.followUserButton = [[MWZComponentFollowUserButton alloc] initWithColor:self.options.mainColor];
    self.followUserButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.followUserButton.delegate = self;
    [self addSubview:self.followUserButton];
}

- (void) applyFollowUserButtonConstraints {
    [[NSLayoutConstraint constraintWithItem:self.followUserButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:self.settings.followUserButtonIsHidden ? 0.0f : 50.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.followUserButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:50.f] setActive:YES];
    
    NSLayoutConstraint* followUserMinY = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0f
                                                                       constant:0.0f];
    followUserMinY.priority = 950;
    followUserMinY.active = YES;
    
    NSLayoutConstraint* followUserButtonRightConstraint;
    NSLayoutConstraint* followUserButtonBottomConstraint;
    if (@available(iOS 11.0, *)) {
        followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:-self.safeAreaInsets.right - 16.0];
        followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:self.safeAreaLayoutGuide
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:-32.0f];
    } else {
        followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:-16.0f];
        followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:-32.0f];
    }
    
    followUserButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.followUserButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:[self.directionScene getBottomViewToConstraint]
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* toBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:[self.defaultScene getBottomViewToConstraint]
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f
                                                                               constant:-16.0f];
    toBottomViewConstraint.priority = 800;
    [toBottomViewConstraint setActive:YES];
    
    [followUserButtonRightConstraint setActive:YES];
    [followUserButtonBottomConstraint setActive:YES];
}

- (void) addCompassView {
    [self.mapView.mapboxMapView.compassView setHidden:YES];
    self.compassView = [[MWZComponentCompass alloc] initWithImage:[UIImage imageNamed:@"compass" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    self.compassView.translatesAutoresizingMaskIntoConstraints = NO;
    self.compassView.delegate = self;
    [self addSubview:self.compassView];
}

- (void) applyCompassConstraints {
    
    [[NSLayoutConstraint constraintWithItem:self.compassView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:self.settings.compassIsHidden ? 0.0f : 40.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.compassView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.compassView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:self.compassView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:[self.defaultScene getTopViewToConstraint]
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:8.0f];
    toSearchBarConstraint.priority = 999;
    [toSearchBarConstraint setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.compassView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:[self.directionScene getTopViewToConstraint]
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
}

- (void) applyFloorControllerConstraint {
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:50.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    if (self.settings.compassIsHidden) {
         NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:self.floorController
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationEqual
         toItem:[self.defaultScene getTopViewToConstraint]
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:8.0f];
         toSearchBarConstraint.priority = 999;
         [toSearchBarConstraint setActive:YES];
         
         [[NSLayoutConstraint constraintWithItem:self.floorController
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationGreaterThanOrEqual
         toItem:[self.directionScene getTopViewToConstraint]
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
     }
}

- (void) addFloorController {
    self.floorController = [[MWZComponentFloorController alloc] initWithColor:self.options.mainColor];
    self.floorController.translatesAutoresizingMaskIntoConstraints = NO;
    self.floorController.floorControllerDelegate = self;
    [self addSubview:self.floorController];
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
    [self setToDirectionPoint:(id<MWZDirectionPoint>)self.selectedContent inSearch:NO];
    [self setIsAccessible:self.isAccessible];
    [self.sceneCoordinator transitionFromDefaultToDirection];
    if (self.fromDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainFroms
                                     universes:[self.mapView getUniverses]
                                activeUniverse:[self.mapView getUniverse]
                                  withLanguage:[self.mapView getLanguage]];
    }
    else if (self.toDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainSearches
             universes:[self.mapView getUniverses]
        activeUniverse:[self.mapView getUniverse]
          withLanguage:[self.mapView getLanguage]];
    }
    else {
        [self startDirection];
    }
    [self unselectContent];
}

- (void) directionToDefaultTransition {
    self.state = MWZViewStateDefault;
    if (self.toDirectionPoint && [self.toDirectionPoint isKindOfClass:MWZPlace.class]) {
        [self selectPlace:(MWZPlace*)self.toDirectionPoint];
    }
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

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    [self.mapView setIndoorLocationProvider:indoorLocationProvider];
}

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure {
    [self.mapView grantAccess:accessKey success:success failure:failure];
}

#pragma mark Content selection
- (void) showSelectedContent {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.language = [self.mapView getLanguage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        defaultProperties.infoButtonHidden = [self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
    }
    else {
        defaultProperties.infoButtonHidden = NO;
    }
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        defaultProperties.infoButtonHidden = [self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
    }
    else {
        defaultProperties.infoButtonHidden = NO;
    }
    [self.defaultScene setSceneProperties:defaultProperties];
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview {
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self selectPlace:place];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void) selectPlaceList:(MWZPlacelist*) placeList {
    if (self.selectedContent) {
        [self.mapView removeMarkers];
        [self.mapView removePromotedPlaces];
    }
    [self.mapView addMarkersOnPlacelist:placeList completionHandler:^(NSArray<MWZMapwizeAnnotation *> * _Nonnull annotation) {
        
    }];
    [self.mapView addPromotedPlacelist:placeList completionHandler:^(NSArray<MWZPlace *> * _Nonnull places) {
        
    }];
    self.selectedContent = placeList;
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.language = [self.mapView getLanguage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        defaultProperties.infoButtonHidden = [self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
    }
    else {
        defaultProperties.infoButtonHidden = NO;
    }
    [self.defaultScene setSceneProperties:defaultProperties];
}

#pragma mark Direction methods
- (void) promoteDirectionPoints {
    [self.mapView removePromotedPlaces];
    if (_toDirectionPoint) {
        if ([_toDirectionPoint isKindOfClass:MWZPlace.class]) {
            [self.mapView addPromotedPlace:(MWZPlace*)_toDirectionPoint];
        }
        if ([_toDirectionPoint isKindOfClass:MWZPlacelist.class]) {
            [self.mapView addPromotedPlacelist:(MWZPlacelist*)_toDirectionPoint completionHandler:^(NSArray<MWZPlace *> * _Nonnull places) {
                
            }];
        }
    }
    if (_fromDirectionPoint) {
        if ([_fromDirectionPoint isKindOfClass:MWZPlace.class]) {
            [self.mapView addPromotedPlace:(MWZPlace*)_fromDirectionPoint];
        }
        if ([_fromDirectionPoint isKindOfClass:MWZPlacelist.class]) {
            [self.mapView addPromotedPlacelist:(MWZPlacelist*)_fromDirectionPoint completionHandler:^(NSArray<MWZPlace *> * _Nonnull places) {
                
            }];
        }
    }
}

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
            [self.directionScene showSearchResults:self.mainSearches
                                         universes:[self.mapView getUniverses]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]];
        }
        else {
            self.state = MWZViewStateDirectionOff;
            [self.directionScene setSearchResultsHidden:YES];
        }
    }
    [self promoteDirectionPoints];
    if ([self shouldStartDirection]) {
        [self startDirection];
    }
}

- (void) setToDirectionPoint:(id<MWZDirectionPoint>)toDirectionPoint inSearch:(BOOL)inSearch {
    [self.mapView removeMarkers];
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
    if (inSearch) {
        [self.directionScene closeToSearch];
        [self.directionScene setSearchResultsHidden:YES];
    }
    self.state = MWZViewStateDirectionOff;
    [self promoteDirectionPoints];
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
            if (self.state == MWZViewStateDirectionOn || self.state == MWZViewStateDirectionOff) {
                self.state = MWZViewStateDirectionOn;
                [self.mapView setDirection:direction];
                [self.directionScene setInfoWith:direction.traveltime
                               directionDistance:direction.distance
                                    isAccessible:self.isAccessible];
                [self.directionScene setDirectionInfoHidden:NO];
            }
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
    [self.languagesButton mapwizeDidEnterInVenue:venue];
    if (self.languagesButton.isHidden) {
        self.universesButtonLeftConstraint.constant = 16.0f;
    }
    else {
        self.universesButtonLeftConstraint.constant =  16.0f * 2 + 50.f;
    }
    [self.universesButton showIfNeeded];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidExit:(MWZVenue *_Nonnull)venue {
    MWZDefaultSceneProperties* defaultProperties = [MWZDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = nil;
    [self.defaultScene setSceneProperties:defaultProperties];
    self.mainSearches = @[];
}

- (void)mapView:(MWZMapView *)mapView floorsDidChange:(NSArray<MWZFloor *> *)floors {
    BOOL showFloorController = !self.settings.floorControllerIsHidden;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowFloorControllerFor:)]) {
        showFloorController = [self.delegate mapwizeView:self shouldShowFloorControllerFor:floors];
    }
    [self.floorController mapwizeFloorsDidChange:floors showController:showFloorController];
}

- (void)mapView:(MWZMapView *)mapView floorDidChange:(MWZFloor*)floor {
    [self.floorController mapwizeFloorDidChange:floor];
}

- (void)mapView:(MWZMapView *)mapView floorWillChange:(MWZFloor*)floor {
    [self.floorController mapwizeFloorWillChange:floor];
}

- (void) mapView:(MWZMapView* _Nonnull) mapView universesDidChange:(NSArray<MWZUniverse*>* _Nonnull) accessibleUniverses {
    [self.universesButton mapwizeAccessibleUniversesDidChange: accessibleUniverses];
}

- (void) mapViewDidLoad:(MWZMapView *)mapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidLoad:)]) {
        [self.delegate mapwizeViewDidLoad:self];
    }
}

#pragma mark MGLMapViewDelegate
- (void) mapView:(MGLMapView *)mapView regionIsChangingWithReason:(MGLCameraChangeReason)reason {
    [self.compassView updateCompass:mapView.direction];
}

- (void) mapViewRegionIsChanging:(MGLMapView *)mapView {
    [self.compassView updateCompass:mapView.direction];
}

- (void) mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.compassView updateCompass:mapView.direction];
}


#pragma mark MWZComponentFloorControllerDelegate
- (void) floorController:(MWZComponentFloorController*) floorController didSelect:(NSNumber*) floorOrder {
    [self.mapView setFloor:floorOrder];
}


#pragma mark MWZDefaultSceneDelegate
- (void) didTapOnSearchButton {
    if ([self.mapView getVenue]) {
        [self.searchScene showSearchResults:self.mainSearches
                                  universes:[self.mapView getUniverses]
                             activeUniverse:[self.mapView getUniverse]
                               withLanguage:[self.mapView getLanguage]];
    }
    else {
        [self.searchScene showResults:self.mainVenues withLanguage:[self.mapView getLanguage]];
    }
    [self mapToSearchTransition];
}

- (void) didTapOnMenuButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidTapOnMenu:)]) {
        [self.delegate mapwizeViewDidTapOnMenu:self];
    }
}

- (void) didTapOnDirectionButton {
    [self defaultToDirectionTransition];
}

- (void) didTapOnInformationButton {
    if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didTapOnPlaceInformationButton:)]) {
            [self.delegate mapwizeView:self didTapOnPlaceInformationButton:(MWZPlace*)self.selectedContent];
        }
    }
    else if ([self.selectedContent isKindOfClass:MWZPlacelist.class]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didTapOnPlacelistInformationButton:)]) {
            [self.delegate mapwizeView:self didTapOnPlacelistInformationButton:(MWZPlacelist*)self.selectedContent];
        }
    }
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
    params.query = query;
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    if (self.state == MWZViewStateSearchVenues) {
        params.objectClass = @[@"venue"];
        if ([query length] == 0) {
            [self.searchScene showResults:self.mainVenues withLanguage:[self.mapView getLanguage]];
            return;
        }
        else {
            [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene showResults:searchResponse
                                           withLanguage:[self.mapView getLanguage]];
                });
            } failure:^(NSError *error) {
                
            }];
        }
    }
    if (self.state == MWZViewStateSearchInVenue) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place", @"placeList"];
        if ([query length] == 0) {
            [self.searchScene showSearchResults:self.mainSearches
                                      universes:[self.mapView getUniverses]
                                 activeUniverse:[self.mapView getUniverse]
                                   withLanguage:[self.mapView getLanguage]];
            return;
        }
        else {
            [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene showSearchResults:searchResponse
                                              universes:[self.mapView getUniverses]
                                         activeUniverse:[self.mapView getUniverse]
                                           withLanguage:[self.mapView getLanguage]];
                });
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    
    
    
}

- (void)didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe {
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
            [self selectPlaceList:(MWZPlacelist*) mapwizeObject];
        }
        if (![universe.identifier isEqualToString:[self.mapView getUniverse].identifier]) {
            [self.mapView setUniverse:universe];
        }
        [self searchToMapTransition];
    }
    else if (self.state == MWZViewStateSearchDirectionFrom) {
        [self setFromDirectionPoint:(id<MWZDirectionPoint>)mapwizeObject];
        
    }
    else if (self.state == MWZViewStateSearchDirectionTo) {
        [self setToDirectionPoint:(id<MWZDirectionPoint>)mapwizeObject inSearch:YES];
        
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
    else if (self.state == MWZViewStateDirectionOn || self.state == MWZViewStateDirectionOff) {
        [self.mapView removeDirection];
        [self directionToDefaultTransition];
    }
}

- (void)directionSceneDidTapOnFromButton:(MWZDirectionScene *)scene {
    if ([self.mapView getVenue]) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        [self.directionScene closeToSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainFroms
                                     universes:[self.mapView getUniverses]
                                activeUniverse:[self.mapView getUniverse]
                                  withLanguage:[self.mapView getLanguage]];
    }
}

- (void)directionSceneDidTapOnToButton:(MWZDirectionScene *)scene {
    if ([self.mapView getVenue] && self.fromDirectionPoint) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene closeFromSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainSearches
                                     universes:[self.mapView getUniverses]
                                activeUniverse:[self.mapView getUniverse]
                                  withLanguage:[self.mapView getLanguage]];
    }
}

- (void) directionSceneDidTapOnSwapButton:(id)directionHeader {
    id tmpFrom = self.toDirectionPoint;
    id tmpTo = self.fromDirectionPoint;
    self.toDirectionPoint = nil;
    self.fromDirectionPoint = nil;
    [self setFromDirectionPoint:tmpFrom];
    [self setToDirectionPoint:tmpTo inSearch:NO];
}

-(void)directionSceneAccessibilityModeDidChange:(BOOL)isAccessible {
    [self setIsAccessible:isAccessible];
    
}

- (void) searchDirectionQueryDidChange:(NSString*) query {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    
    if (self.state == MWZViewStateSearchDirectionTo) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place", @"placeList"];
        params.universeId = [self.mapView getUniverse].identifier;
        if ([query length] == 0) {
            [self.directionScene showSearchResults:self.mainSearches
                                      universes:[self.mapView getUniverses]
                                 activeUniverse:[self.mapView getUniverse]
                                   withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    if (self.state == MWZViewStateSearchDirectionFrom) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place"];
        params.universeId = [self.mapView getUniverse].identifier;
        if ([query length] == 0) {
            [self.directionScene showSearchResults:self.mainFroms
                 universes:[self.mapView getUniverses]
            activeUniverse:[self.mapView getUniverse]
              withLanguage:[self.mapView getLanguage]];
            return;
        }
    }
    
    params.query = query;
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.directionScene showSearchResults:searchResponse
                                         universes:[self.mapView getUniverses]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]];
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark MWZComponentCompassDelegate

- (void) didPress:(MWZComponentCompass *)compass {
    [self.mapView setFollowUserMode:MWZFollowUserModeNone];
    [self.mapView.mapboxMapView setDirection:0 animated:YES];
}

#pragma mark MWZComponentFollowUserButtonDelegate
- (void)didTapWithoutLocation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidTapOnFollowWithoutLocation:)]) {
        [self.delegate mapwizeViewDidTapOnFollowWithoutLocation:self];
    }
}

- (void)followUserButton:(MWZComponentFollowUserButton *)followUserButton didChangeFollowUserMode:(MWZFollowUserMode)followUserMode {
    [self.mapView setFollowUserMode:followUserMode];
}

- (MWZFollowUserMode)followUserButtonRequiresFollowUserMode:(MWZComponentFollowUserButton *)followUserButton {
    return [self.mapView getFollowUserMode];
}

- (ILIndoorLocation *)followUserButtonRequiresUserLocation:(MWZComponentFollowUserButton *)followUserButton {
    return [self.mapView getUserLocation];
}

#pragma mark MWZComponentUniversesDelegate
- (void)didSelectUniverse:(MWZUniverse *)universe {
    [self.mapView setUniverse:universe];
}

#pragma mark MWZComponentLanguagesDelegate
- (void)didSelectLanguage:(NSString *)language {
    [self.mapView setLanguage:language forVenue:[self.mapView getVenue]];
}


@end
