#import "MWZMapwizeView.h"
#import "MWZComponentFollowUserButton.h"
#import "MWZComponentBottomInfoView.h"
#import "MWZComponentSearchBar.h"
#import "MWZSearchData.h"
#import "MWZComponentSearchBarDelegate.h"
#import "MWZComponentCompass.h"
#import "MWZComponentCompassDelegate.h"
#import "MWZComponentFloorController.h"
#import "MWZComponentDirectionBar.h"
#import "MWZComponentDirectionBarDelegate.h"
#import "MWZComponentDirectionInfo.h"
#import "MWZComponentBottomInfoViewDelegate.h"
#import "MWZComponentLoadingBar.h"
#import "MWZMapwizeViewDelegate.h"
#import "MWZComponentFollowUserButtonDelegate.h"
#import "MWZComponentUniversesButton.h"
#import "MWZComponentUniversesButtonDelegate.h"
#import "MWZIndoorLocation.h"
#import "MWZComponentLanguagesButton.h"
#import "MWZComponentLanguagesButtonDelegate.h"
#import "MWZMapwizeViewUISettings.h"
#import "MWZUIOptions.h"

@interface MWZMapwizeView () <MGLMapViewDelegate, MWZMapViewDelegate,
    MWZComponentSearchBarDelegate, MWZComponentCompassDelegate,
    MWZComponentDirectionBarDelegate, MWZComponentBottomInfoViewDelegate,
    MWZComponentFollowUserButtonDelegate, MWZComponentUniversesButtonDelegate,
    MWZComponentLanguagesButtonDelegate, MWZComponentFloorControllerDelegate>

@end

const CGFloat marginTop = 0;
const CGFloat marginLeft = 16;
const CGFloat marginBottom = 40;
const CGFloat marginRight = 16;

@implementation MWZMapwizeView {
    
    MWZComponentFollowUserButton* followUserButton;
    NSLayoutConstraint* qrCodeButtonBottomConstraint;
    NSLayoutConstraint* qrCodeButtonHeightConstraint;
    NSLayoutConstraint* qrCodeButtonWidthConstraint;
    NSLayoutConstraint* qrCodeButtonRightConstraint;
    NSLayoutConstraint* followUserButtonBottomConstraint;
    NSLayoutConstraint* followUserButtonHeightConstraint;
    NSLayoutConstraint* followUserButtonWidthConstraint;
    NSLayoutConstraint* followUserButtonRightConstraint;
    NSLayoutConstraint* searchBarTopConstraint;
    NSLayoutConstraint* universesButtonLeftConstraint;
    
    MWZComponentBottomInfoView* bottomInfoView;
    MWZComponentCompass* compassView;
    MWZComponentSearchBar* searchBar;
    MWZComponentFloorController* floorController;
    MWZComponentDirectionBar* directionBar;
    MWZComponentDirectionInfo* directionInfo;
    MWZComponentLoadingBar* loadingBar;
    MWZComponentUniversesButton* universesButton;
    MWZComponentLanguagesButton* languagesButton;
    
    MWZMapwizeViewUISettings* uiSettings;
    
    MWZSearchData* searchData;
    id<MWZObject> selectedContent;
    
    BOOL isInDirection;
}

- (instancetype) initWithFrame:(CGRect)frame mapwizeOptions:(MWZUIOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeWithFrame:frame mapwizeConfiguration:[MWZMapwizeConfiguration sharedInstance] options:options uiSettings:uiSettings];
        self.backgroundColor = UIColor.redColor;
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeWithFrame:frame mapwizeConfiguration:mapwizeConfiguration options:options uiSettings:uiSettings];
    }
    return self;
}

/*- (void) handleOptions:(MWZUIOptions*) options {
    if (options.centerOnPlaceId) {
        [MWZApi getPlaceWithId:options.centerOnPlaceId success:^(MWZPlace *place) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MGLMapCamera* camera = [[MGLMapCamera alloc] init];
                camera.centerCoordinate = place.marker.coordinates;
                camera.altitude = 500.0f;
                [self.mapboxMap setCamera:camera];
                self->selectedContent = place;
                [self.mapwizePlugin setUniverse:self->selectedContent.universes[0]];
            });
        } failure:^(NSError *error) {
            // TODO handle error
        }];
    }
    else if (options.centerOnVenueId) {
        [MWZApi getVenueWithId:options.centerOnVenueId success:^(MWZVenue *venue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MGLMapCamera* camera = [[MGLMapCamera alloc] init];
                camera.centerCoordinate = venue.marker.coordinates;
                camera.altitude = 1000.0f;
                [self.mapboxMap setCamera:camera];
            });
        } failure:^(NSError *error) {
            // TODO handle error
        }];
    }
    else if (options.centerOnLocation != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MGLMapCamera* camera = [[MGLMapCamera alloc] init];
            camera.centerCoordinate = options.centerOnLocation.coordinates;
            camera.altitude = 500.0f;
            [self.mapView setFloor:options.centerOnLocation.floor];
            [self.mapView addMarker:options.centerOnLocation completionHandler:^(MWZMapwizeAnnotation* annotation) {
                
            }];
            [self.mapboxMap setCamera:camera];
        });
    }
}*/

- (void) initializeWithFrame:(CGRect) frame
        mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                     options:(MWZOptions*) options
                  uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self->isInDirection = NO;
    self->searchData = [[MWZSearchData alloc] init];
    self->uiSettings = uiSettings;
    _mapView = [[MWZMapView alloc] initWithFrame:frame options:options mapwizeConfiguration:mapwizeConfiguration];
    _mapView.delegate = self;
    _mapView.mapboxDelegate = self;
    [self addSubview:_mapView];
    
    id<MWZMapwizeApi> mapwizeApi = [MWZMapwizeApiFactory getApiWithMapwizeConfiguration:mapwizeConfiguration];
    [self instantiateUIComponents:uiSettings mapwizeApi:mapwizeApi];
    
    /*NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString* apiKey = dict[@"MWZMapwizeApiKey"];
    NSURL* styleUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://outdoor.mapwize.io/styles/mapwize/style.json?key=%@", apiKey]];
    _mapboxMap = [[MGLMapView alloc] initWithFrame:frame styleURL:styleUrl];
    [_mapboxMap.compassView setHidden:YES];
    [self addSubview:_mapboxMap];
    
    // Hide default sdk controller
    MWZUISettings* sdkUISettings = [[MWZUISettings alloc] init];
    sdkUISettings.showFloorControl = NO;
    sdkUISettings.showUserPositionControl = NO;
    sdkUISettings.mapwizeCompassEnabled = NO;
    sdkUISettings.mainColor = uiSettings.mainColor;
    // Remove centerOn options. MapwizeUI handle it by itself to improve performance
    options.centerOnVenueId = nil;
    options.centerOnPlaceId = nil;
    
    _mapwizePlugin = [[MapwizePlugin alloc] initWith:_mapboxMap options:options uiSettings:sdkUISettings];
    _mapwizePlugin.delegate = self;
    _mapwizePlugin.mapboxDelegate = self;*/
}

- (void) instantiateUIComponents:(MWZMapwizeViewUISettings*) settings mapwizeApi:(id<MWZMapwizeApi>) mapwizeApi {
    [self addViews:settings mapwizeApi:mapwizeApi];
    [self setupConstraintsToSearchBar: settings];
    [self setupConstraintsToDirectionBar: settings];
    [self setupConstraintsToBottomInfoView:settings];
    [self setupConstraintsToFollowUserButton: settings];
    [self setupConstraintsToCompass: settings];
    [self setupConstraintsToFloorController: settings];
    [self setupConstraintsToLoadingBar:settings];
    [self setupConstraintsToLanguagesButton];
    [self setupConstraintsToUniversesButton];
}

- (void) addViews:(MWZMapwizeViewUISettings*) settings mapwizeApi:(id<MWZMapwizeApi>) mapwizeApi {
    loadingBar = [[MWZComponentLoadingBar alloc] initWithColor:settings.mainColor];
    loadingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:loadingBar];
    
    floorController = [[MWZComponentFloorController alloc] init];
    floorController.translatesAutoresizingMaskIntoConstraints = NO;
    floorController.showsVerticalScrollIndicator = NO;
    floorController.floorControllerDelegate = self;
    [self addSubview:floorController];
    
    if (!uiSettings.compassIsHidden) {
        compassView = [[MWZComponentCompass alloc] initWithImage:_mapView.mapboxMapView.compassView.image];
        compassView.translatesAutoresizingMaskIntoConstraints = NO;
        compassView.delegate = self;
        [self addSubview:compassView];
    }
    
    followUserButton = [[MWZComponentFollowUserButton alloc] initWithColor:settings.mainColor];
    followUserButton.translatesAutoresizingMaskIntoConstraints = NO;
    followUserButton.delegate = self;
    [self addSubview:followUserButton];
    
    languagesButton = [[MWZComponentLanguagesButton alloc] init];
    languagesButton.translatesAutoresizingMaskIntoConstraints = NO;
    languagesButton.delegate = self;
    [self addSubview:languagesButton];
    
    universesButton = [[MWZComponentUniversesButton alloc] init];
    universesButton.translatesAutoresizingMaskIntoConstraints = NO;
    universesButton.delegate = self;
    [self addSubview:universesButton];
    
    searchBar = [[MWZComponentSearchBar alloc] initWith:searchData uiSettings:uiSettings mapwizeApi:mapwizeApi];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.delegate = self;
    [self addSubview:searchBar];
    
    directionBar = [[MWZComponentDirectionBar alloc] initWithMapwizeApi:mapwizeApi searchData:searchData color:settings.mainColor];
    directionBar.translatesAutoresizingMaskIntoConstraints = NO;
    directionBar.delegate = self;
    [self addSubview:directionBar];
    
    bottomInfoView = [[MWZComponentBottomInfoView alloc] initWithColor:uiSettings.mainColor];
    bottomInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomInfoView.delegate = self;
    [self addSubview:bottomInfoView];
    
}

- (void) setupConstraintsToLoadingBar:(MWZMapwizeViewUISettings*) settings {
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:searchBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:2.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:directionBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:2.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loadingBar
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:3.0f] setActive:YES];
}
    
- (void) setupConstraintsToDirectionBar:(MWZMapwizeViewUISettings*) settings {
    [[NSLayoutConstraint constraintWithItem:directionBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:directionBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:directionBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    directionInfo = [[MWZComponentDirectionInfo alloc] initWithColor:settings.mainColor];
    directionInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:directionInfo];
    [[NSLayoutConstraint constraintWithItem:directionInfo
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:directionInfo
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}
    
- (void) showDirectionUI {
    [directionBar setTo:(id<MWZDirectionPoint>)selectedContent];
    if ([_mapView getUserLocation] && [_mapView getUserLocation].floor) {
        [directionBar setFrom:[[MWZIndoorLocation alloc] initWith:[_mapView getUserLocation]]];
    }
    [universesButton setHidden:YES];
    [languagesButton setHidden:YES];
    isInDirection = YES;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self->searchBar.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    }];
    [directionBar show];
    [bottomInfoView unselectContent];
}
    
- (void) showDefaultUI {
    if (selectedContent) {
        if ([selectedContent isKindOfClass:MWZPlace.class]) {
            if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
                [bottomInfoView selectContentWithPlace:(MWZPlace*) selectedContent
                                              language:[_mapView getLanguage]
                                        showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlace*) selectedContent]];
            }
            else {
                [bottomInfoView selectContentWithPlace:(MWZPlace*) selectedContent
                                              language:[_mapView getLanguage]
                                        showInfoButton:NO];
            }
        }
        if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            [bottomInfoView selectContentWithPlaceList:(MWZPlacelist*) selectedContent
                                              language:[_mapView getLanguage]
                                        showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlacelist*) selectedContent]];
        }
        else {
            [bottomInfoView selectContentWithPlaceList:(MWZPlacelist*) selectedContent
                                              language:[_mapView getLanguage]
                                        showInfoButton:NO];
        }
    }
    if ([_mapView getVenue]) {
        [languagesButton mapwizeDidEnterInVenue:[_mapView getVenue]];
        if (self->languagesButton.isHidden) {
            self->universesButtonLeftConstraint.constant = marginLeft;
        }
        else {
            self->universesButtonLeftConstraint.constant = marginLeft * 2 + 50.f;
        }
    }
    isInDirection = NO;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self->searchBar.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
    [directionBar hide];
}
    
- (void) setupConstraintsToFloorController:(MWZMapwizeViewUISettings*) uiSettings {
    [[NSLayoutConstraint constraintWithItem:floorController
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:48.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:floorController
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:followUserButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:floorController
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:followUserButton
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (uiSettings.compassIsHidden) {
        NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:floorController
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:searchBar
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0f
                                                                                  constant:8.0f];
        toSearchBarConstraint.priority = 999;
        [toSearchBarConstraint setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:floorController
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:directionBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    else {
        [[NSLayoutConstraint constraintWithItem:floorController
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:compassView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    
}

- (void) setupConstraintsToCompass:(MWZMapwizeViewUISettings*) uiSettings {
    if (uiSettings.compassIsHidden) {
        return;
    }
    [[NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:_mapView.mapboxMapView.compassView.frame.size.width] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:_mapView.mapboxMapView.compassView.frame.size.height] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:followUserButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:searchBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f];
    toSearchBarConstraint.priority = 999;
    [toSearchBarConstraint setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:directionBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    
}

- (void) setupConstraintsToSearchBar:(MWZMapwizeViewUISettings*) uiSettings {
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:searchBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    
    
}

- (void) setupConstraintsToBottomInfoView:(MWZMapwizeViewUISettings*) uiSettings {
    [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:bottomInfoView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f] setActive:YES];
    
}

- (void) setupConstraintsToFollowUserButton:(MWZMapwizeViewUISettings*) settings {
    followUserButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:50.f];
    
    if (settings.followUserButtonIsHidden) {
        followUserButtonHeightConstraint.constant = 0.0f;
    }
    
    followUserButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:50.f];
    
    NSLayoutConstraint* followUserMinY = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0.0f];
    followUserMinY.priority = 950;
    followUserMinY.active = YES;
    
    if (@available(iOS 11.0, *)) {
        followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:-self.safeAreaInsets.right - marginRight];
        followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:self.safeAreaLayoutGuide
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:-marginBottom];
    } else {
        followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:-marginRight];
        followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:-marginBottom];
    }
    
    followUserButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:followUserButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* toBottomViewConstraint = [NSLayoutConstraint constraintWithItem:followUserButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:bottomInfoView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f];
    toBottomViewConstraint.priority = 800;
    [toBottomViewConstraint setActive:YES];
    
    [followUserButtonHeightConstraint setActive:YES];
    [followUserButtonWidthConstraint setActive:YES];
    [followUserButtonRightConstraint setActive:YES];
    [followUserButtonBottomConstraint setActive:YES];
}

- (void) setupConstraintsToLanguagesButton {
    NSLayoutConstraint* languagesButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1.0f
                                                                                        constant:50.f];
    
    NSLayoutConstraint* languagesButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                                      attribute:NSLayoutAttributeWidth
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:nil
                                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                                     multiplier:1.0f
                                                                                       constant:50.f];
    
    NSLayoutConstraint* languagesButtonMinY = [NSLayoutConstraint constraintWithItem:languagesButton
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
        languagesButtonRightConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:self.safeAreaInsets.left + marginLeft];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant: -marginBottom];
    }
    else {
        languagesButtonRightConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:marginLeft];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    
    languagesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:languagesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* languagesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:languagesButton
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:bottomInfoView
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

- (void) setupConstraintsToUniversesButton {
    NSLayoutConstraint* universesButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1.0f
                                                                                        constant:50.f];
    
    NSLayoutConstraint* universesButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:50.f];

    NSLayoutConstraint* universeButtonMinY = [NSLayoutConstraint constraintWithItem:universesButton
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
        universesButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:marginLeft * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    else {
        universesButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:marginLeft * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    
    universesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:universesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* universesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:universesButton
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:bottomInfoView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f
                                                                               constant:-16.0f];
    universesToBottomViewConstraint.priority = 800;
    [universesToBottomViewConstraint setActive:YES];
    
    [universesButtonHeightConstraint setActive:YES];
    [universesButtonWidthConstraint setActive:YES];
    [universesButtonLeftConstraint setActive:YES];
    [universesButtonBottomConstraint setActive:YES];
}

- (void) loadVenuesInSearchData {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.query = @"";
    params.objectClass = @[@"venue"];
    [_mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        [self->searchData.venues addObjectsFromArray:searchResponse];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainSearchesInSearchData:(MWZVenue*) venue {
    [self->searchData.mainSearch removeAllObjects];
    [_mapView.mapwizeApi getMainSearchesWithVenue:venue success:^(NSArray<id<MWZObject>> *mainSearches) {
        [self->searchData.mainSearch addObjectsFromArray:mainSearches];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainFromsInSearchData:(MWZVenue*) venue {
    [self->searchData.mainFrom removeAllObjects];
    [_mapView.mapwizeApi getMainFromsWithVenue:venue success:^(NSArray<MWZPlace *> *places) {
         [self->searchData.mainFrom addObjectsFromArray:places];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadAccessibleUniversesInSearchData:(MWZVenue*) venue {
    [self->searchData.accessibleUniverses removeAllObjects];
    [self->searchData.accessibleUniverses addObjectsFromArray:venue.universes];
}

- (void) unselectContent:(BOOL) closeInfo {
    [_mapView removeMarkers];
    [_mapView removePromotedPlaces];
    selectedContent = nil;
    if (closeInfo) {
        [bottomInfoView unselectContent];
    }
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview centerOn:(BOOL) centerOn {
    [self unselectContent:NO];
    [_mapView addMarkerOnCoordinate:placePreview.defaultCenter];
    if (centerOn) {
        [_mapView centerOnPlacePreview:placePreview animated:true];
    }
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self.mapView addPromotedPlace:place];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            [self->bottomInfoView selectContentWithPlace:place
                                          language:[self.mapView getLanguage]
                                    showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:place]];
        }
        else {
            [self->bottomInfoView selectContentWithPlace:place
                                          language:[self.mapView getLanguage]
                                    showInfoButton:NO];
        }
        
        self->selectedContent = place;
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn {
    [self unselectContent:NO];
    if (centerOn) {
        [_mapView centerOnPlace:place animated:YES];
    }
    [_mapView addMarkerOnPlace:place];
    [_mapView addPromotedPlace:place];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [bottomInfoView selectContentWithPlace:place
                                      language:[_mapView getLanguage]
                                showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:place]];
    }
    else {
        [bottomInfoView selectContentWithPlace:place
                                      language:[_mapView getLanguage]
                                showInfoButton:NO];
    }
    
    selectedContent = place;
}

- (void) selectPlaceList:(MWZPlacelist*) placeList {
    [self unselectContent:NO];
    [_mapView addMarkersOnPlacelist:placeList completionHandler:^(NSArray<MWZMapwizeAnnotation *> * _Nonnull handler) {
        
    }];
    if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [bottomInfoView selectContentWithPlaceList:placeList
                                      language:[_mapView getLanguage]
                                showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:placeList]];
    }
    else {
        [bottomInfoView selectContentWithPlaceList:placeList
                                      language:[_mapView getLanguage]
                                showInfoButton:NO];
    }
    selectedContent = placeList;
}

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    if (_mapView) {
        [_mapView setIndoorLocationProvider:indoorLocationProvider];
    }
}

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure {
    [_mapView grantAccess:accessKey success:success failure:failure];
}

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible {
    isInDirection = YES;
    [self showDirectionUI];
    [directionBar setAccessibility:isAccessible];
    [directionBar setFrom:from];
    [directionBar setTo:to];
}

#pragma mark MWZMapwizePluginDelegate

- (void) mapViewDidLoad:(MWZMapView *)mapView {
    [self loadVenuesInSearchData];
    if (_delegate) {
        [_delegate mapwizeViewDidLoad:self];
    }
}

- (void) mapView:(MWZMapView *)mapView followUserModeDidChange:(MWZFollowUserMode)followUserMode {
    [followUserButton setFollowUserMode:followUserMode];
}

- (void) mapView:(MWZMapView *)mapView venueWillEnter:(MWZVenue *)venue {
    [self loadMainSearchesInSearchData:venue];
    [self loadMainFromsInSearchData:venue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->searchBar mapwizeWillEnterInVenue:venue];
        [self->loadingBar startAnimation];
    });
}

- (void) mapView:(MWZMapView *)mapView venueDidEnter:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->searchBar mapwizeDidEnterInVenue:venue];
        [self->loadingBar stopAnimation];
        [self->languagesButton mapwizeDidEnterInVenue:venue];
        if (self->languagesButton.isHidden) {
            self->universesButtonLeftConstraint.constant = marginLeft;
        }
        else {
            self->universesButtonLeftConstraint.constant = marginLeft * 2 + 50.f;
        }
        if (venue.universes.count > 0) {
            [self handleUniverseUpdate:venue.universes[0]];
        }
        [self loadAccessibleUniversesInSearchData:venue];
        if ([self->selectedContent isKindOfClass:[MWZPlace class]]) {
            [self selectPlace:(MWZPlace*)self->selectedContent centerOn:NO];
            [self.mapView setFloor:((MWZPlace*) self->selectedContent).floor];
        }
        else if ([self->selectedContent isKindOfClass:[MWZPlacelist class]]) {
            [self selectPlaceList:(MWZPlacelist*) self->selectedContent];
        }
    });
}

- (void) mapView:(MWZMapView *)mapView venueDidExit:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->loadingBar stopAnimation];
        [self->languagesButton mapwizeDidExitVenue];
        [self->searchBar mapwizeDidExitVenue:venue];
    });
}

- (void) mapView:(MWZMapView *)mapView floorsDidChange:(NSArray<MWZFloor *> *)floors {
    if (self->uiSettings.floorControllerIsHidden) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mapwizeView:shouldShowFloorControllerFor:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->floorController mapwizeFloorsDidChange:floors
                                           showController:[self.delegate mapwizeView:self shouldShowFloorControllerFor:floors]];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->floorController mapwizeFloorsDidChange:floors
                                           showController:true];
        });
    }
}

- (void) mapView:(MWZMapView *)mapView floorDidChange:(MWZFloor *)floor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->floorController mapwizeFloorDidChange:floor];
    });
}

- (void) mapView:(MWZMapView *)mapView didTap:(MWZClickEvent *)clickEvent {
    if (isInDirection) {
        return;
    }
    switch (clickEvent.eventType) {
        case PLACE_CLICK:
            [self selectPlacePreview:clickEvent.placePreview centerOn:NO];
            break;
        case VENUE_CLICK:
            [_mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
            break;
        default:
            [self unselectContent:YES];
            break;
    }
}

- (void) mapView:(MWZMapView* _Nonnull) mapView accessibleUniversesDidChange:(NSArray<MWZUniverse*>* _Nonnull) accessibleUniverses {
    [universesButton mapwizeAccessibleUniversesDidChange: accessibleUniverses];
}

- (void) handleUniverseUpdate: (MWZUniverse *) universe {
    if (_delegate && [_delegate respondsToSelector:@selector(mapwizeUniverseHasChanged:)]) {
        [_delegate mapwizeUniverseHasChanged:universe];
    }
}

#pragma mark MWZComponentBottomInfoViewDelegate
    
- (void) didPressInformation {
    if (_delegate) {
        if ([selectedContent isKindOfClass:MWZPlace.class]) {
            [_delegate mapwizeView:self didTapOnPlaceInformationButton:(MWZPlace*)selectedContent];
        }
        if ([selectedContent isKindOfClass:MWZPlacelist.class]) {
            [_delegate mapwizeView:self didTapOnPlaceListInformationButton:(MWZPlacelist*)selectedContent];
        }
    }
}
    
#pragma mark MWZComponentSearchBarDelegate

- (void) didPressDirection {
    [self showDirectionUI];
}

- (void) didPressMenu {
    if (_delegate) {
        [_delegate mapwizeViewDidTapOnMenu:self];
    }
}

- (void) didSelectPlace:(MWZPlace *)place universe:(MWZUniverse *)universe {
    if (![universe.identifier isEqualToString:[self.mapView getUniverse].identifier]) {
        [self.mapView setUniverse:universe];
    }
    [self selectPlace:place centerOn:YES];
}

- (void) didSelectPlaceList:(MWZPlacelist *)placelist universe:(MWZUniverse *)universe {
    if (![universe.identifier isEqualToString:[self.mapView getUniverse].identifier]) {
        [self.mapView setUniverse:universe];
    }
    [self selectPlaceList:placelist];
}

- (void) didSelectVenue:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView centerOnVenue:venue animated:YES];
    });
}

#pragma mark MWZComponentCompassDelegate

- (void) didPress:(MWZComponentCompass *)compass {
    [_mapView setFollowUserMode:NONE];
    [_mapView.mapboxMapView setDirection:0 animated:YES];
}
    
#pragma mark MWZComponentDirectionBarDelegate
    
- (void) didPressBack {
    [self showDefaultUI];
}
    
- (void) didUpdateDirectionInfo:(double) travelTime distance:(double) distance {
    [self unselectContent:YES];
    [directionInfo setInfoWith:travelTime directionDistance:distance];
}
    
- (void) didStopDirection {
    [_mapView removeDirection];
    [_mapView removePromotedPlaces];
    [directionInfo close];
}

- (void) didStartLoading {
    [self bringSubviewToFront:loadingBar];
    [loadingBar startAnimation];
}

- (void) didStopLoading {
    [loadingBar stopAnimation];
}

- (NSString *)searchBarRequiresCurrentLanguage:(MWZComponentSearchBar *)searchBar {
    return [_mapView getLanguage];
}


- (MWZUniverse *)searchBarRequiresCurrentUniverse:(MWZComponentSearchBar *)searchBar {
    return [_mapView getUniverse];
}


- (MWZVenue *)searchBarRequiresCurrentVenue:(MWZComponentSearchBar *)searchBar {
    return [_mapView getVenue];
}


- (void)didFindDirection:(MWZDirection *)direction from:(id<MWZDirectionPoint>)from to:(id<MWZDirectionPoint>)to isAccessible:(BOOL) isAccessible {
    [_mapView setDirection:direction];
    [self unselectContent:YES];
    [directionInfo setInfoWith:direction.traveltime directionDistance:direction.distance];
}


- (NSString *)directionBarRequiresCurrentLanguage:(MWZComponentDirectionBar *)directionBar {
    return [_mapView getLanguage];
}


- (MWZUniverse *)directionBarRequiresCurrentUniverse:(MWZComponentDirectionBar *)directionBar {
    return [_mapView getUniverse];
}


- (MWZVenue *)directionBarRequiresCurrentVenue:(MWZComponentDirectionBar *)directionBar {
    return [_mapView getVenue];
}


- (ILIndoorLocation *)directionBarRequiresUserLocation:(MWZComponentDirectionBar *)directionBar {
    return [_mapView getUserLocation];
}


#pragma mark MGLMapViewDelegate

- (void) mapViewRegionIsChanging:(MGLMapView *)mapView {
    [compassView updateCompass:mapView.direction];
}

- (void) mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [compassView updateCompass:mapView.direction];
}

#pragma mark MWZComponentFollowUserButtonDelegate

- (void) didTapWithoutLocation {
    if (_delegate) {
        [_delegate mapwizeViewDidTapOnFollowWithoutLocation:self];
    }
}

- (void)followUserButton:(MWZComponentFollowUserButton *)followUserButton didChangeFollowUserMode:(MWZFollowUserMode)followUserMode {
    [_mapView setFollowUserMode:followUserMode];
}


- (MWZFollowUserMode)followUserButtonRequiresFollowUserMode:(MWZComponentFollowUserButton *)followUserButton {
    return [_mapView getFollowUserMode];
}


- (ILIndoorLocation *)followUserButtonRequiresUserLocation:(MWZComponentFollowUserButton *)followUserButton {
    return [_mapView getUserLocation];
}


#pragma mark MWZComponentUniversesButtonDelegate

- (void) didSelectUniverse:(MWZUniverse *)universe {
    if (selectedContent) {
        [self unselectContent:YES];
    }
    [self handleUniverseUpdate:universe];
    [_mapView setUniverse:universe];
}

#pragma mark MWZComponentLanguagesButtonDelegate

- (void) didSelectLanguage:(NSString *)language {
    [_mapView setLanguage:language forVenue:[_mapView getVenue]];
}

- (void)floorController:(MWZComponentFloorController *)floorController didSelect:(NSNumber *)floorOrder {
    [_mapView setFloor:floorOrder];
}

@end
