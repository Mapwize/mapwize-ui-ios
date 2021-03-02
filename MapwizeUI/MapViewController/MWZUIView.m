#import "MWZUIView.h"
#import "MWZUISearchScene.h"
#import "MWZUIDefaultScene.h"
#import "MWZUIDirectionScene.h"
#import "ILIndoorLocation+DirectionPoint.h"
#import "MWZUIDefaultSceneProperties.h"
#import "MWZUIFloorController.h"
#import "MWZUIFollowUserButton.h"
#import "MWZUICompass.h"
#import "MWZUIUniversesButton.h"
#import "MWZUILanguagesButton.h"
#import "MWZUIOptions.h"
#import "MWZUISettings.h"
#import "MWZUIViewDelegate.h"
#import "MWZUISearchSceneDelegate.h"
#import "MWZUIDefaultSceneDelegate.h"
#import "MWZUIDirectionSceneDelegate.h"
#import "MWZUISceneCoordinator.h"
#import "MWZUIFloorControllerDelegate.h"
#import "MWZUICompassDelegate.h"
#import "MWZUIFollowUserButtonDelegate.h"
#import "MWZUILanguagesButtonDelegate.h"
#import "MWZUIUniversesButtonDelegate.h"
#import "MWZUIBottomSheetComponents.h"
#import "MWZUIOpeningHoursUtils.h"
#import "MWZUIIssuesReportingViewController.h"


typedef NS_ENUM(NSUInteger, MWZViewState) {
    MWZViewStateDefault,
    MWZViewStateDirectionOff,
    MWZViewStateDirectionOn,
    MWZViewStateSearchVenues,
    MWZViewStateSearchInVenue,
    MWZViewStateSearchDirectionFrom,
    MWZViewStateSearchDirectionTo
};

@interface MWZUIView () <UIViewControllerTransitioningDelegate, MWZUISearchSceneDelegate,
MWZUIDefaultSceneDelegate, MWZUIDirectionSceneDelegate, MWZMapViewDelegate,
MWZUIFloorControllerDelegate, MWZUICompassDelegate,
MWZUIFollowUserButtonDelegate, MGLMapViewDelegate,
MWZUIUniversesButtonDelegate,MWZUILanguagesButtonDelegate>

@property (nonatomic) MWZUIOptions* options;
@property (nonatomic) MWZUISettings* settings;

@property (nonatomic) MWZUIFloorController* floorController;
@property (nonatomic) MWZUIUniversesButton* universesButton;
@property (nonatomic) MWZUILanguagesButton* languagesButton;

@property (nonatomic) MWZUISceneCoordinator* sceneCoordinator;
@property (nonatomic) MWZUISearchScene* searchScene;
@property (nonatomic) MWZUIDefaultScene* defaultScene;
@property (nonatomic) MWZUIDirectionScene* directionScene;

@property (nonatomic) NSArray<MWZVenue*>* mainVenues;
@property (nonatomic) NSArray<id<MWZObject>>* mainSearches;
@property (nonatomic) NSArray<MWZPlace*>* mainFroms;
@property (nonatomic) id selectedContent;

@property (nonatomic) id<MWZDirectionPoint> fromDirectionPoint;
@property (nonatomic) id<MWZDirectionPoint> toDirectionPoint;
@property (nonatomic) MWZDirectionMode* directionMode;
@property (nonatomic, assign) MWZViewState state;

@property (nonatomic) NSLayoutConstraint* universesButtonLeftConstraint;

@end

@implementation MWZUIView

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZUISettings*) uiSettings {
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
                    uiSettings:(MWZUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        _settings = uiSettings;
        _options = options;
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
    self.sceneCoordinator = [[MWZUISceneCoordinator alloc] initWithContainerView:self];
    
    self.defaultScene = [[MWZUIDefaultScene alloc] initWith:self.options.mainColor menuIsHidden:self.settings.menuButtonIsHidden];
    self.defaultScene.delegate = self;
    self.sceneCoordinator.defaultScene = self.defaultScene;

    self.searchScene = [[MWZUISearchScene alloc] initWith:self.options.mainColor];
    self.searchScene.delegate = self;
    self.sceneCoordinator.searchScene = self.searchScene;
    
    self.directionScene = [[MWZUIDirectionScene alloc] initWith:self.options.mainColor];
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
                [self selectPlace:place  centerOn:NO];
            });
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    
}

- (void) addLanguagesButton {
    self.languagesButton = [[MWZUILanguagesButton alloc] init];
    self.languagesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.languagesButton.delegate = self;
    [self.languagesButton setHidden:YES];
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
    self.universesButton = [[MWZUIUniversesButton alloc] init];
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
    self.followUserButton = [[MWZUIFollowUserButton alloc] initWithColor:self.options.mainColor];
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
    self.compassView = [[MWZUICompass alloc] initWithImage:[UIImage imageNamed:@"compass" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
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
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
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
    self.floorController = [[MWZUIFloorController alloc] initWithColor:self.options.mainColor];
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
    [self.universesButton showIfNeeded];
    [self.sceneCoordinator transitionFromSearchToDefault];
}

- (void) defaultToDirectionTransition {
    self.state = MWZViewStateDirectionOff;
    self.fromDirectionPoint = nil;
    self.toDirectionPoint = nil;
    [self.universesButton setHidden:YES];
    [self setDirectionMode:self.directionMode];
    [self setFromDirectionPoint:[self.mapView getUserLocation]];
    [self setToDirectionPoint:(id<MWZDirectionPoint>)self.selectedContent inSearch:NO];
    [self.sceneCoordinator transitionFromDefaultToDirection];
    
    if (self.fromDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        if ([self.mapView getUserLocation] && [self.mapView getUserLocation].floor) {
            [self.directionScene setCurrentLocationViewHidden:NO];
        }
        else {
            [self.directionScene setCurrentLocationViewHidden:YES];
        }
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainFroms
                                     universes:@[[self.mapView getUniverse]]
                                activeUniverse:[self.mapView getUniverse]
                                  withLanguage:[self.mapView getLanguage]
                                      forQuery:@""];
    }
    else if (self.toDirectionPoint == nil) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene setCurrentLocationViewHidden:YES];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene showSearchResults:self.mainSearches
             universes:@[[self.mapView getUniverse]]
        activeUniverse:[self.mapView getUniverse]
          withLanguage:[self.mapView getLanguage]
              forQuery:@""];
    }
    [self unselectContent];
}

- (void) directionToDefaultTransition {
    self.state = MWZViewStateDefault;
    [self.universesButton showIfNeeded];
    if (self.toDirectionPoint && [self.toDirectionPoint isKindOfClass:MWZPlace.class]) {
        [self selectPlace:(MWZPlace*)self.toDirectionPoint centerOn:NO];
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

- (void) setDirection:(MWZDirection*) direction
                 from:(id<MWZDirectionPoint>) from
                   to:(id<MWZDirectionPoint>) to
        directionMode:(MWZDirectionMode*) directionMode {
    [self defaultToDirectionTransitionWithDirection:direction from:from to:to directionMode:directionMode];
}

- (void) defaultToDirectionTransitionWithDirection:(MWZDirection*) direction
                                              from:(id<MWZDirectionPoint>) from
                                                to:(id<MWZDirectionPoint>) to
                                     directionMode:(MWZDirectionMode*) directionMode {
    self.state = MWZViewStateDirectionOff;
    [self.universesButton setHidden:YES];
    [self.sceneCoordinator transitionFromDefaultToDirection];
    [self setDirectionMode:directionMode];
    [self setToDirectionPoint:to inSearch:NO];
    [self setFromDirectionPoint:from];
}

#pragma mark Content selection
- (void) showSelectedContent {
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.language = [self.mapView getLanguage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        defaultProperties.infoButtonHidden = ![self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
    }
    else {
        defaultProperties.infoButtonHidden = YES;
    }
    [self.defaultScene setSceneProperties:defaultProperties];
    if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
        [self.mapView removeMarkers];
        [self.mapView selectPlace:(MWZPlace*)self.selectedContent];
    }
}

- (void) unselectContent {
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = nil;
    [self.defaultScene setSceneProperties:defaultProperties];
    [self.mapView unselectPlace];
    [self.mapView removeMarkers];
    self.selectedContent = nil;
}

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn{
    if (centerOn) {
        [self.mapView centerOnPlace:place animated:YES];
    }
    [self.mapView removeMarkers];
    [self.mapView selectPlace:place];
    self.selectedContent = place;
    
    [_mapView.mapwizeApi getPlaceDetailsWithPlaceIdentifier:place.identifier success:^(MWZPlaceDetails * _Nonnull details) {
        MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
        defaultProperties.selectedContent = self.selectedContent;
        defaultProperties.language = [self.mapView getLanguage];
        defaultProperties.placeDetails = details;
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            defaultProperties.infoButtonHidden = ![self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
        }
        else {
            defaultProperties.infoButtonHidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.defaultScene setSceneProperties:defaultProperties];
        });
    } failure:^(NSError * _Nonnull error) {
        MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
        defaultProperties.selectedContent = self.selectedContent;
        defaultProperties.placeDetails = nil;
        defaultProperties.language = [self.mapView getLanguage];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            defaultProperties.infoButtonHidden = ![self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
        }
        else {
            defaultProperties.infoButtonHidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.defaultScene setSceneProperties:defaultProperties];
        });
    }];
    
    
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview {
    _selectedContent = placePreview;
    [self.mapView removeMarkers];
    [self.mapView selectPlacePreview:placePreview];
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = placePreview;
    defaultProperties.language = [self.mapView getLanguage];
    defaultProperties.infoButtonHidden = YES;
    [self.defaultScene setSceneProperties:defaultProperties];
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        if ([self.selectedContent isKindOfClass:MWZPlacePreview.class] && [((MWZPlacePreview*)self.selectedContent).identifier isEqualToString:place.identifier]) {
            [self selectPlace:place centerOn:NO];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}

- (void) selectPlaceList:(MWZPlacelist*) placeList {
    [self.mapView unselectPlace];
    [self.mapView removeMarkers];
    
    [self.mapView.mapwizeApi getPlacesForPlacelistWithIdentifier:placeList.identifier success:^(NSArray<MWZPlace *> * _Nonnull places) {
        NSMutableArray<MWZMarker*>* markers = [[NSMutableArray alloc] init];
        for (MWZPlace* place in places) {
            MWZMarker* marker = [MWZMarker markerWithPlace:place options:[[MWZMarkerOptions alloc] init]];
            [markers addObject:marker];
        }
        [self.mapView addMarkers:markers];
        if (places.count == 0) {
            return;
        }
        BOOL shouldSetFloor = YES;
        if ([self.mapView getFloor]) {
            for (MWZPlace* place in places) {
                if ([[self.mapView getFloorNumber] isEqual:place.floor]){
                    shouldSetFloor = NO;
                    break;
                }
            }
        }
        if (shouldSetFloor) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView centerOnPlace:places[0] animated:YES];
            });
        }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    
    self.selectedContent = placeList;
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.selectedContent = self.selectedContent;
    defaultProperties.placeDetails = nil;
    defaultProperties.language = [self.mapView getLanguage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        defaultProperties.infoButtonHidden = ![self.delegate mapwizeView:self shouldShowInformationButtonFor:self.selectedContent];
    }
    else {
        defaultProperties.infoButtonHidden = YES;
    }
    [self.defaultScene setSceneProperties:defaultProperties];
}

#pragma mark Direction methods
- (void) promoteDirectionPoints {
    /*[self.mapView removePromotedPlaces];
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
    }*/
}

- (void) setFromDirectionPoint:(id<MWZDirectionPoint>)fromDirectionPoint {
    _fromDirectionPoint = fromDirectionPoint;
    if (fromDirectionPoint == nil || ([fromDirectionPoint isKindOfClass:ILIndoorLocation.class]
                                      && !((ILIndoorLocation*)fromDirectionPoint).floor)) {
        _fromDirectionPoint = nil;
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
            [self.directionScene setCurrentLocationViewHidden:YES];
            
            [self.directionScene showSearchResults:self.mainSearches
                                         universes:@[[self.mapView getUniverse]]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]
                                          forQuery:@""];
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
        [self.directionScene setCurrentLocationViewHidden:YES];
        [self.directionScene setSearchResultsHidden:YES];
    }
    self.state = MWZViewStateDirectionOff;
    [self promoteDirectionPoints];
    if ([self shouldStartDirection]) {
        [self startDirection];
    }
}

-(void) setDirectionMode:(MWZDirectionMode*)directionMode {
    _directionMode = directionMode;
    [self.directionScene setSelectedMode:directionMode];
    if (self.state == MWZViewStateDirectionOn) {
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
    if ([self.fromDirectionPoint isKindOfClass:ILIndoorLocation.class]
        && ((ILIndoorLocation*)self.fromDirectionPoint).floor) {
        [self.directionScene showLoading];
        MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
        options.endMarkerOptions = [[MWZMarkerOptions alloc] init];
        options.endMarkerOptions.iconName = @"direction-end-marker-icon";
        options.endMarkerOptions.iconScale = @0.4;
        options.endMarkerOptions.titleOffset = @[@1, @0];
        options.endMarkerOptions.titleAnchor = @"left";
        if ([self.toDirectionPoint isKindOfClass:MWZPlace.class]) {
            options.endMarkerOptions.title = [((MWZPlace*)self.toDirectionPoint) titleForLanguage:[self.mapView getLanguage]];
        }
        else if ([self.toDirectionPoint isKindOfClass:MWZPlacelist.class]) {
            options.endMarkerOptions.title = [((MWZPlacelist*)self.toDirectionPoint) titleForLanguage:[self.mapView getLanguage]];
        }
        [self.mapView startNavigation:self.toDirectionPoint directionMode:self.directionMode options:options];
        self.state = MWZViewStateDirectionOn;
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didStartDirectionInVenue:universe:from:to:mode:isNavigation:)]) {
            [self.delegate mapwizeView:self didStartDirectionInVenue:[self.mapView getVenue] universe:[self.mapView getUniverse] from:self.fromDirectionPoint to:self.toDirectionPoint mode:self.directionMode.identifier isNavigation:YES];
        }
    }
    else {
        [self.directionScene showLoading];
        [self.mapView.mapwizeApi getDirectionWithFrom:self.fromDirectionPoint
                                                   to:self.toDirectionPoint
                                        directionMode:self.directionMode success:^(MWZDirection * _Nonnull direction) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.state == MWZViewStateDirectionOn || self.state == MWZViewStateDirectionOff) {
                    [self.directionScene hideLoading];
                    self.state = MWZViewStateDirectionOn;
                    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
                    options.endMarkerOptions = [[MWZMarkerOptions alloc] init];
                    options.endMarkerOptions.iconName = @"direction-end-marker-icon";
                    options.endMarkerOptions.iconScale = @0.4;
                    options.endMarkerOptions.titleOffset = @[@1, @0];
                    options.endMarkerOptions.titleAnchor = @"left";
                    if ([self.toDirectionPoint isKindOfClass:MWZPlace.class]) {
                        options.endMarkerOptions.title = [((MWZPlace*)self.toDirectionPoint) titleForLanguage:[self.mapView getLanguage]];
                    }
                    else if ([self.toDirectionPoint isKindOfClass:MWZPlacelist.class]) {
                        options.endMarkerOptions.title = [((MWZPlacelist*)self.toDirectionPoint) titleForLanguage:[self.mapView getLanguage]];
                    }
                    
                    options.startMarkerOptions = [[MWZMarkerOptions alloc] init];
                    options.startMarkerOptions.iconName = @"direction-start-marker-icon";
                    options.startMarkerOptions.iconScale = @0.4;
                    options.startMarkerOptions.titleOffset = @[@1, @0];
                    options.startMarkerOptions.titleAnchor = @"left";
                    if ([self.fromDirectionPoint isKindOfClass:MWZPlace.class]) {
                        options.startMarkerOptions.title = [((MWZPlace*)self.fromDirectionPoint) titleForLanguage:[self.mapView getLanguage]];
                    }
                    
                    [self.mapView setDirection:direction options:options];
                    [self.directionScene setInfoWith:direction.traveltime
                                   directionDistance:direction.distance
                                       directionMode:self.directionMode];
                    [self.directionScene setDirectionInfoHidden:NO];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didStartDirectionInVenue:universe:from:to:mode:isNavigation:)]) {
                        [self.delegate mapwizeView:self didStartDirectionInVenue:[self.mapView getVenue] universe:[self.mapView getUniverse] from:self.fromDirectionPoint to:self.toDirectionPoint mode:self.directionMode.identifier isNavigation:NO];
                    }
                }
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.directionScene hideLoading];
                [self.directionScene showErrorMessage:NSLocalizedString(@"Direction not found",@"")];
                [self.mapView removeDirection];
            });
        }];
    }
}

- (void) dispatchDidFailLoadingContent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidFailLoadingContent:)]) {
        [self.delegate mapwizeViewDidFailLoadingContent:self];
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

#pragma mark MWZUIFloorControllerDelegate
- (void) floorController:(MWZUIFloorController*) floorController didSelect:(NSNumber*) floorOrder {
    [self.mapView setFloor:floorOrder];
}


#pragma mark MWZDefaultSceneDelegate
- (void) didTapOnSearchButton {
    if ([self.mapView getVenue]) {
        [self.searchScene showSearchResults:self.mainSearches
                                  universes:[self.mapView getUniverses]
                             activeUniverse:[self.mapView getUniverse]
                               withLanguage:[self.mapView getLanguage]
                                   forQuery:@""];
    }
    else {
        [self.searchScene showResults:self.mainVenues withLanguage:[self.mapView getLanguage] forQuery:@""];
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

- (void) didTapOnCallButton {
    NSLog(@"SHOW PHONE CALL");
}
- (void) didTapOnShareButton {
    NSLog(@"SHOW SHARE PLACE");
}
- (void) didTapOnWebsiteButton {
    NSLog(@"SHOW WEBSITE");
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

- (void) didClose {
    [self unselectContent];
}

- (MWZUIBottomSheetComponents*) requireComponentForPlaceDetails:(MWZPlaceDetails*)placeDetails withDefaultComponents:(MWZUIBottomSheetComponents*)components {
    if (_delegate && [_delegate respondsToSelector:@selector(mapwizeView:requireComponentForPlaceDetails:withDefaultComponents:)]) {
        return [_delegate mapwizeView:self requireComponentForPlaceDetails:placeDetails withDefaultComponents:components];
    }
    return components;
}

- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components {
    return components;
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
            [self.searchScene showResults:self.mainVenues withLanguage:[self.mapView getLanguage] forQuery:@""];
            return;
        }
        else {
            [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene showResults:searchResponse
                                           withLanguage:[self.mapView getLanguage] forQuery:query];
                    [self.searchScene setNetworkError:NO];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene setNetworkError:YES];
                });
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
                                   withLanguage:[self.mapView getLanguage]
                                       forQuery:@""];
            return;
        }
        else {
            [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene showSearchResults:searchResponse
                                              universes:[self.mapView getUniverses]
                                         activeUniverse:[self.mapView getUniverse]
                                           withLanguage:[self.mapView getLanguage]
                                               forQuery:query];
                    [self.searchScene setNetworkError:NO];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchScene setNetworkError:YES];
                });
            }];
        }
    }
}


- (void)didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse *)universe forQuery:(NSString *)query {
    if (self.state == MWZViewStateSearchVenues) {
        [self.mapView centerOnVenue:(MWZVenue*)mapwizeObject animated:YES];
        [self searchToMapTransition];
    }
    else if (self.state == MWZViewStateSearchInVenue) {
        if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
            [self.mapView centerOnPlace:(MWZPlace*)mapwizeObject animated:YES];
            [self selectPlace:(MWZPlace*)mapwizeObject centerOn:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didSelectPlace:currentUniverse:searchResultUniverse:channel:searchQuery:)]) {
                [self.delegate mapwizeView:self
                            didSelectPlace:(MWZPlace*)mapwizeObject
                           currentUniverse:[self.mapView getUniverse]
                      searchResultUniverse:universe == nil ? [self.mapView getUniverse]: universe
                                   channel:query.length > 0 ? MWZUIEventChannelSearch : MWZUIEventChannelMainSearch
                               searchQuery:query];
            }
        }
        if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
            [self selectPlaceList:(MWZPlacelist*) mapwizeObject];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didSelectPlace:currentUniverse:searchResultUniverse:channel:searchQuery:)]) {
                [self.delegate mapwizeView:self
                            didSelectPlacelist:(MWZPlacelist*)mapwizeObject
                            currentUniverse:[self.mapView getUniverse]
                        searchResultUniverse:universe == nil ? [self.mapView getUniverse]: universe
                                    channel:query.length > 0 ? MWZUIEventChannelSearch : MWZUIEventChannelMainSearch
                                searchQuery:query];
            }
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
        if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didSelectPlace:currentUniverse:searchResultUniverse:channel:searchQuery:)]) {
                [self.delegate mapwizeView:self
                            didSelectPlace:(MWZPlace*)mapwizeObject
                           currentUniverse:[self.mapView getUniverse]
                      searchResultUniverse:universe == nil ? [self.mapView getUniverse]: universe
                                   channel:query.length > 0 ? MWZUIEventChannelSearch : MWZUIEventChannelMainSearch
                               searchQuery:query];
            }
        }
        if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didSelectPlace:currentUniverse:searchResultUniverse:channel:searchQuery:)]) {
                [self.delegate mapwizeView:self
                            didSelectPlacelist:(MWZPlacelist*)mapwizeObject
                            currentUniverse:[self.mapView getUniverse]
                        searchResultUniverse:universe == nil ? [self.mapView getUniverse]: universe
                                    channel:query.length > 0 ? MWZUIEventChannelSearch : MWZUIEventChannelMainSearch
                                searchQuery:query];
            }
        }
    }
}

#pragma mark MWZDirectionSceneDelegate
- (void) directionSceneDidTapOnCurrentLocation:(MWZUIDirectionScene*) scene {
    [self setFromDirectionPoint:[self.mapView getUserLocation]];
}
- (void)directionSceneDidTapOnBackButton:(MWZUIDirectionScene *)scene {
    if (self.state == MWZViewStateSearchDirectionFrom || self.state == MWZViewStateSearchDirectionTo) {
        [self.directionScene closeFromSearch];
        [self.directionScene closeToSearch];
        [self.directionScene setCurrentLocationViewHidden:YES];
        [self.directionScene setSearchResultsHidden:YES];
        if ([self.mapView getDirection]) {
            self.state = MWZViewStateDirectionOn;
            if (![[self.mapView getDirection].directionMode isEqual:_directionMode] && [self shouldStartDirection]) {
                [self startDirection];
            }
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

- (void)directionSceneDidTapOnFromButton:(MWZUIDirectionScene *)scene {
    if ([self.mapView getVenue]) {
        self.state = MWZViewStateSearchDirectionFrom;
        [self.directionScene openFromSearch];
        [self.directionScene closeToSearch];
        [self.directionScene setSearchResultsHidden:NO];
        if ([self.mapView getUserLocation] && [self.mapView getUserLocation].floor) {
            [self.directionScene setCurrentLocationViewHidden:NO];
        }
        else {
            [self.directionScene setCurrentLocationViewHidden:YES];
        }
    }
}

- (void)directionSceneDidTapOnToButton:(MWZUIDirectionScene *)scene {
    if ([self.mapView getVenue] && self.fromDirectionPoint) {
        self.state = MWZViewStateSearchDirectionTo;
        [self.directionScene openToSearch];
        [self.directionScene closeFromSearch];
        [self.directionScene setSearchResultsHidden:NO];
        [self.directionScene setCurrentLocationViewHidden:YES];
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

-(void)directionSceneDirectionModeDidChange:(MWZDirectionMode*)directionMode {
    [self setDirectionMode:directionMode];
}

- (void) searchDirectionQueryDidChange:(NSString*) query {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    
    if (self.state == MWZViewStateSearchDirectionTo) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place", @"placeList"];
        params.universeId = [self.mapView getUniverse].identifier;
        if ([query length] == 0) {
            [self.directionScene showSearchResults:self.mainSearches
                                         universes:@[[self.mapView getUniverse]]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]
                                          forQuery:@""];
            return;
        }
    }
    if (self.state == MWZViewStateSearchDirectionFrom) {
        params.venueId = [self.mapView getVenue].identifier;
        params.objectClass = @[@"place"];
        params.universeId = [self.mapView getUniverse].identifier;
        if ([query length] == 0) {
            [self.directionScene showSearchResults:self.mainFroms
                                         universes:@[[self.mapView getUniverse]]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]
                                          forQuery:@""];
            return;
        }
    }
    
    params.query = query;
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.directionScene showSearchResults:searchResponse
                                         universes:@[[self.mapView getUniverse]]
                                    activeUniverse:[self.mapView getUniverse]
                                      withLanguage:[self.mapView getLanguage]
                                          forQuery:query];
            [self.searchScene setNetworkError:NO];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchScene setNetworkError:YES];
        });
    }];
}

#pragma mark MWZUICompassDelegate

- (void) didPress:(MWZUICompass *)compass {
    [self.mapView setFollowUserMode:MWZFollowUserModeNone];
    [self.mapView.mapboxMapView setDirection:0 animated:YES];
}

#pragma mark MWZUIFollowUserButtonDelegate
- (void)didTapWithoutLocation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidTapOnFollowWithoutLocation:)]) {
        [self.delegate mapwizeViewDidTapOnFollowWithoutLocation:self];
    }
}

- (void)followUserButton:(MWZUIFollowUserButton *)followUserButton didChangeFollowUserMode:(MWZFollowUserMode)followUserMode {
    [self.mapView setFollowUserMode:followUserMode];
}

- (MWZFollowUserMode)followUserButtonRequiresFollowUserMode:(MWZUIFollowUserButton *)followUserButton {
    return [self.mapView getFollowUserMode];
}

- (ILIndoorLocation *)followUserButtonRequiresUserLocation:(MWZUIFollowUserButton *)followUserButton {
    return [self.mapView getUserLocation];
}

#pragma mark MWZUIUniversesDelegate
- (void)didSelectUniverse:(MWZUniverse *)universe {
    [self.mapView setUniverse:universe];
}

#pragma mark MWZUILanguagesDelegate
- (void)didSelectLanguage:(NSString *)language {
    [self.mapView setLanguage:language forVenue:[self.mapView getVenue]];
}

#pragma mark MWZMapViewDelegate

- (void) mapViewDidLoad:(MWZMapView *)mapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidLoad:)]) {
        [self.delegate mapwizeViewDidLoad:self];
    }
}

- (void)mapView:(MWZMapView *)mapView followUserModeDidChange:(MWZFollowUserMode)followUserMode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:followUserModeDidChange:)]) {
        [self.delegate mapwizeView:self followUserModeDidChange:followUserMode];
    }
    [self.followUserButton setFollowUserMode:followUserMode];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView didTap:(MWZClickEvent *_Nonnull)clickEvent {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didTap:)]) {
        [self.delegate mapwizeView:self didTap:clickEvent];
    }
    
    if (self.state != MWZViewStateDefault) {
        return;
    }
    switch (clickEvent.eventType) {
        case MWZClickEventTypeVenueClick: {
            [self.mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
        }
            break;
        case MWZClickEventTypePlaceClick: {
            [self selectPlacePreview:clickEvent.placePreview];
            [clickEvent.placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didSelectPlace:currentUniverse:searchResultUniverse:channel:searchQuery:)]) {
                        [self.delegate mapwizeView:self
                                    didSelectPlace:place
                                   currentUniverse:[self.mapView getUniverse]
                              searchResultUniverse:[self.mapView getUniverse]
                                           channel:MWZUIEventChannelMapClick
                                       searchQuery:nil];
                    }
                });
            } failure:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
        default:
            [self unselectContent];
            break;
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueWillEnter:(MWZVenue *_Nonnull)venue {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:venueWillEnter:)]) {
        [self.delegate mapwizeView:self venueWillEnter:venue];
    }
    [self fetchMainSearchesForVenues:venue];
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = venue;
    defaultProperties.venueLoading = YES;
    [self.defaultScene setSceneProperties:defaultProperties];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidEnter:(MWZVenue *_Nonnull)venue {
    
    /*MWZUIIssuesReportingViewController* issueController = [[MWZUIIssuesReportingViewController alloc] initWithVenue:venue place:nil userInfo:nil color:_options.mainColor];
    [self.window.rootViewController presentViewController:issueController animated:YES completion:nil];
    */
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:venueDidEnter:)]) {
        [self.delegate mapwizeView:self venueDidEnter:venue];
    }
    
    
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = venue;
    defaultProperties.venueLoading = NO;
    [self.defaultScene setSceneProperties:defaultProperties];
    [self.languagesButton mapwizeDidEnterInVenue:venue];
    [self.languagesButton setHidden:([venue.supportedLanguages count] == 1)];
    if (self.languagesButton.isHidden) {
        self.universesButtonLeftConstraint.constant = 16.0f;
    }
    else {
        self.universesButtonLeftConstraint.constant =  16.0f * 2 + 50.f;
    }
    [self.universesButton showIfNeeded];
    
    MWZUIIssuesReportingViewController* issueController = [[MWZUIIssuesReportingViewController alloc] initWithVenue:venue placeDetails:nil userInfo:nil language:[mapView getLanguage] color:_options.mainColor];
    [self.window.rootViewController presentViewController:issueController animated:YES completion:nil];

}

- (void)mapView:(MWZMapView *)mapView venueDidFailEntering:(MWZVenue *)venue withError:(NSError *)error {
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = venue;
    defaultProperties.venueLoading = NO;
    [self.defaultScene setSceneProperties:defaultProperties];
    [self.languagesButton mapwizeDidEnterInVenue:venue];
    [self.languagesButton setHidden:([venue.supportedLanguages count] == 1)];
    if (self.languagesButton.isHidden) {
        self.universesButtonLeftConstraint.constant = 16.0f;
    }
    else {
        self.universesButtonLeftConstraint.constant =  16.0f * 2 + 50.f;
    }
    [self.universesButton showIfNeeded];
    [self dispatchDidFailLoadingContent];
}

- (void)mapView:(MWZMapView *)mapView directionModesDidChange:(NSArray<MWZDirectionMode *> *)directionModes {
    [self.directionScene setAvailableModes:directionModes];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidExit:(MWZVenue *_Nonnull)venue {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:venueDidExit:)]) {
        [self.delegate mapwizeView:self venueDidExit:venue];
    }
    MWZUIDefaultSceneProperties* defaultProperties = [MWZUIDefaultSceneProperties scenePropertiesWithProperties:self.defaultScene.sceneProperties];
    defaultProperties.venue = nil;
    [self.languagesButton setHidden:YES];
    [self.defaultScene setSceneProperties:defaultProperties];
    self.mainSearches = @[];
    [self unselectContent];
}

- (void) mapView:(MWZMapView *)mapView universeWillChange:(MWZUniverse *)universe {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:universeWillChange:)]) {
        [self.delegate mapwizeView:self universeWillChange:universe];
    }
}

- (void) mapView:(MWZMapView *)mapView universeDidChange:(MWZUniverse *)universe {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:universeDidChange:)]) {
        [self.delegate mapwizeView:self universeDidChange:universe];
    }
    BOOL universeExists = NO;
    if ([self.selectedContent isKindOfClass:MWZPlacePreview.class]) {
        return;
    }
    for (MWZUniverse* u in ((id<MWZObject>)self.selectedContent).universes) {
        if ([u.identifier isEqualToString:universe.identifier]) {
            universeExists = YES;
        }
    }
    if (self.selectedContent && !universeExists) {
        [self unselectContent];
    }
}

- (void) mapView:(MWZMapView *)mapView universeDidFailChanging:(MWZUniverse *)universe withError:(NSError *)error {
    if (self.selectedContent) {
        [self unselectContent];
    }
    [self dispatchDidFailLoadingContent];
}

- (void) mapView:(MWZMapView* _Nonnull) mapView universesDidChange:(NSArray<MWZUniverse*>* _Nonnull) accessibleUniverses {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:universesDidChange:)]) {
        [self.delegate mapwizeView:self universesDidChange:accessibleUniverses];
    }
    [self.universesButton mapwizeAccessibleUniversesDidChange: accessibleUniverses];
}

- (void)mapView:(MWZMapView *)mapView floorWillChange:(MWZFloor*)floor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:floorWillChange:)]) {
        [self.delegate mapwizeView:self floorWillChange:floor];
    }
    [self.floorController mapwizeFloorWillChange:floor];
}

- (void)mapView:(MWZMapView *)mapView floorDidChange:(MWZFloor*)floor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:floorDidChange:)]) {
        [self.delegate mapwizeView:self floorDidChange:floor];
    }
    [self.floorController mapwizeFloorDidChange:floor];
}

- (void)mapView:(MWZMapView *)mapView floorDidFailChanging:(MWZFloor *)floor withError:(NSError *)error {
    [self.floorController mapwizeFloorDidChange:nil];
    [self dispatchDidFailLoadingContent];
}

- (void)mapView:(MWZMapView *)mapView floorsDidChange:(NSArray<MWZFloor *> *)floors {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:floorsDidChange:)]) {
        [self.delegate mapwizeView:self floorsDidChange:floors];
    }
    BOOL showFloorController = !self.settings.floorControllerIsHidden;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowFloorControllerFor:)]) {
        showFloorController = [self.delegate mapwizeView:self shouldShowFloorControllerFor:floors];
    }
    [self.floorController mapwizeFloorsDidChange:floors showController:showFloorController language:[mapView getLanguage]];
}

- (void)mapView:(MWZMapView *)mapView languageDidChange:(NSString *)language {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:languageDidChange:)]) {
        [self.delegate mapwizeView:self languageDidChange:language];
    }
}

- (MWZUserLocationAnnotationView *_Nonnull)viewForUserLocationAnnotation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForUserLocationAnnotation)]) {
        return [self.delegate viewForUserLocationAnnotation];
    }
    return [[MWZUserLocationAnnotationView alloc] initWithFrame:CGRectZero
                                                   onFloorColor:self.options.mainColor
                                                outOfFloorColor:[UIColor lightGrayColor]];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView didTapOnMarker:(MWZMapwizeAnnotation *_Nonnull)marker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didTapOnMarker:)]) {
        [self.delegate mapwizeView:self didTapOnMarker:marker];
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView didTapMarker:(MWZMarker *_Nonnull)marker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:didTapMarker:)]) {
        [self.delegate mapwizeView:self didTapMarker:marker];
    }
}

- (void)mapViewWillStartNavigation:(MWZMapView *_Nonnull)mapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewWillStartNavigation:)]) {
        [self.delegate mapwizeViewWillStartNavigation:self];
    }
}

- (void)mapViewDidStartNavigation:(MWZMapView *)mapView forDirection:(MWZDirection *)direction {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeViewDidStartNavigation:forDirection:)]) {
            [self.delegate mapwizeViewDidStartNavigation:self forDirection:direction];
        }
        
        [self.directionScene hideLoading];
        [self.directionScene setInfoWith:direction.traveltime
                       directionDistance:direction.distance
                           directionMode:self.directionMode];
        [self.directionScene setDirectionInfoHidden:NO];
    });
}

- (void)mapView:(MWZMapView *)mapView navigationFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:navigationFailedWithError:)]) {
            [self.delegate mapwizeView:self navigationFailedWithError:error];
        }
        [self.directionScene hideLoading];
        [self.directionScene showErrorMessage:NSLocalizedString(@"Direction not found", &"")];
        [self.mapView removeDirection];
    });
}

- (BOOL)mapView:(MWZMapView *_Nonnull) mapView shouldRecomputeNavigation:(MWZNavigationInfo* _Nonnull) navigationInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldRecomputeNavigation:)]) {
        return [self.delegate mapwizeView:self shouldRecomputeNavigation:navigationInfo];
    }
    return navigationInfo.locationDelta > 10 && [self.mapView getUserLocation] && [self.mapView getUserLocation].floor;
}

@end
