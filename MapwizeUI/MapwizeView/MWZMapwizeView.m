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

@interface MWZMapwizeView () <MGLMapViewDelegate, MWZMapwizePluginDelegate,
    MWZComponentSearchBarDelegate, MWZComponentCompassDelegate,
    MWZComponentDirectionBarDelegate, MWZComponentBottomInfoViewDelegate,
    MWZComponentFollowUserButtonDelegate, MWZComponentUniversesButtonDelegate,
    MWZComponentLanguagesButtonDelegate>

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

- (instancetype) initWithFrame:(CGRect)frame mapwizeOptions:(MWZOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        self->isInDirection = NO;
        self->searchData = [[MWZSearchData alloc] init];
        [self handleOptions:options settings:uiSettings];
        self->uiSettings = uiSettings;
        [self instantiateMap:frame options:options uiSettings:uiSettings];
        [self instantiateUIComponents:uiSettings];
    }
    return self;
}

- (void) handleOptions:(MWZOptions*) options settings:(MWZMapwizeViewUISettings*) settings {
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
}

- (void) instantiateMap:(CGRect) frame options:(MWZOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
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
    _mapwizePlugin.mapboxDelegate = self;
}

- (void) injectMapwizeToComponents:(MapwizePlugin*) mapwizePlugin {
    followUserButton.mapwizePlugin = mapwizePlugin;
    searchBar.mapwizePlugin = mapwizePlugin;
    floorController.mapwizePlugin = mapwizePlugin;
    directionBar.mapwizePlugin = mapwizePlugin;
}

- (void) instantiateUIComponents:(MWZMapwizeViewUISettings*) settings {
    [self addViews:settings];
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

- (void) addViews:(MWZMapwizeViewUISettings*) settings {
    loadingBar = [[MWZComponentLoadingBar alloc] initWithColor:settings.mainColor];
    loadingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:loadingBar];
    
    floorController = [[MWZComponentFloorController alloc] init];
    floorController.translatesAutoresizingMaskIntoConstraints = NO;
    floorController.showsVerticalScrollIndicator = NO;
    [self addSubview:floorController];
    
    if (!uiSettings.compassIsHidden) {
        compassView = [[MWZComponentCompass alloc] initWithImage:_mapboxMap.compassView.image];
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
    
    searchBar = [[MWZComponentSearchBar alloc] initWith:searchData uiSettings:uiSettings];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.delegate = self;
    [self addSubview:searchBar];
    
    directionBar = [[MWZComponentDirectionBar alloc] initWith:searchData color:settings.mainColor];
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
    if (_mapwizePlugin.userLocation && _mapwizePlugin.userLocation.floor) {
        [directionBar setFrom:[[MWZIndoorLocation alloc] initWith:_mapwizePlugin.userLocation]];
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
                                              language:[_mapwizePlugin getLanguage]
                                        showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlace*) selectedContent]];
            }
            else {
                [bottomInfoView selectContentWithPlace:(MWZPlace*) selectedContent
                                              language:[_mapwizePlugin getLanguage]
                                        showInfoButton:NO];
            }
        }
        if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            [bottomInfoView selectContentWithPlaceList:(MWZPlaceList*) selectedContent
                                              language:[_mapwizePlugin getLanguage]
                                        showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlaceList*) selectedContent]];
        }
        else {
            [bottomInfoView selectContentWithPlaceList:(MWZPlaceList*) selectedContent
                                              language:[_mapwizePlugin getLanguage]
                                        showInfoButton:NO];
        }
    }
    if ([_mapwizePlugin getVenue]) {
        [languagesButton mapwizeDidEnterInVenue:[_mapwizePlugin getVenue]];
        if (self->languagesButton.isHidden) {
            self->universesButtonLeftConstraint.constant = marginLeft;
        }
        else {
            self->universesButtonLeftConstraint.constant = marginLeft * 2 + 50.f;
        }
        [universesButton mapwizeDidEnterInVenue:[_mapwizePlugin getVenue]];
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
                                   constant:_mapboxMap.compassView.frame.size.width] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:compassView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:_mapboxMap.compassView.frame.size.height] setActive:YES];
    
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
    [MWZApi searchWithParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        [self->searchData.venues addObjectsFromArray:searchResponse];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainSearchesInSearchData:(MWZVenue*) venue {
    [self->searchData.mainSearch removeAllObjects];
    [MWZApi getMainSearchesWithVenue:venue success:^(NSArray<id<MWZObject>> *mainSearches) {
        [self->searchData.mainSearch addObjectsFromArray:mainSearches];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainFromsInSearchData:(MWZVenue*) venue {
    [self->searchData.mainFrom removeAllObjects];
    [MWZApi getMainFromsWithVenue:venue success:^(NSArray<MWZPlace *> *places) {
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
    if (selectedContent) {
        [_mapwizePlugin removeMarkers];
        [_mapwizePlugin removePromotedPlacesForVenue:[_mapwizePlugin getVenue]];
        selectedContent = nil;
        if (closeInfo) {
            [bottomInfoView unselectContent];
        }
    }
}

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn {
    [self unselectContent:NO];
    if (centerOn) {
        [_mapwizePlugin centerOnPlace:place];
    }
    [_mapwizePlugin addMarkerOnPlace:place];
    [_mapwizePlugin addPromotedPlace:place];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [bottomInfoView selectContentWithPlace:place
                                      language:[_mapwizePlugin getLanguage]
                                showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:place]];
    }
    else {
        [bottomInfoView selectContentWithPlace:place
                                      language:[_mapwizePlugin getLanguage]
                                showInfoButton:NO];
    }
    
    selectedContent = place;
}

- (void) selectPlaceList:(MWZPlaceList*) placeList {
    [self unselectContent:NO];
    [_mapwizePlugin addMarkersOnPlaceList:placeList];
    if (_delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [bottomInfoView selectContentWithPlaceList:placeList
                                      language:[_mapwizePlugin getLanguage]
                                showInfoButton:[_delegate mapwizeView:self shouldShowInformationButtonFor:placeList]];
    }
    else {
        [bottomInfoView selectContentWithPlaceList:placeList
                                      language:[_mapwizePlugin getLanguage]
                                showInfoButton:NO];
    }
    selectedContent = placeList;
}

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    if (_mapwizePlugin) {
        [_mapwizePlugin setIndoorLocationProvider:indoorLocationProvider];
    }
}

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure {
    [_mapwizePlugin grantAccess:accessKey success:^{
        if ([_mapwizePlugin getVenue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->universesButton mapwizeDidEnterInVenue:[_mapwizePlugin getVenue]];
            });
        }
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible {
    isInDirection = YES;
    [self showDirectionUI];
    [directionBar setAccessibility:isAccessible];
    [directionBar setFrom:from];
    [directionBar setTo:to];
}

#pragma mark MWZMapwizePluginDelegate

- (void) mapwizePluginDidLoad:(MapwizePlugin*) mapwizePlugin {
    [self injectMapwizeToComponents:mapwizePlugin];
    [self loadVenuesInSearchData];
    if (_delegate) {
        [_delegate mapwizeViewDidLoad:self];
    }
}

- (void) plugin:(MapwizePlugin*) plugin didChangeFollowUserMode:(FollowUserMode) followUserMode {
    [followUserButton setFollowUserMode:followUserMode];
}

- (void) plugin:(MapwizePlugin*) plugin willEnterVenue:(MWZVenue*) venue {
    [self loadMainSearchesInSearchData:venue];
    [self loadMainFromsInSearchData:venue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->searchBar mapwizeWillEnterInVenue:venue];
        [self->loadingBar startAnimation];
    });
}

- (void) plugin:(MapwizePlugin*) plugin didEnterVenue:(MWZVenue*) venue {
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
        [self->universesButton mapwizeDidEnterInVenue:venue];
        [self loadAccessibleUniversesInSearchData:venue];
        if (self->selectedContent) {
            [self selectPlace:(MWZPlace*)self->selectedContent centerOn:NO];
            [self.mapwizePlugin setFloor:((MWZPlace*) self->selectedContent).floor];
        }
    });
}

- (void) plugin:(MapwizePlugin*) plugin didExitVenue:(MWZVenue*) venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->languagesButton mapwizeDidExitVenue];
        [self->universesButton mapwizeDidExitVenue];
        [self->searchBar mapwizeDidExitVenue:venue];
    });
}

- (void) plugin:(MapwizePlugin*) plugin didChangeFloor:(NSNumber*) floor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->floorController mapwizeFloorDidChange:floor];
    });
}

- (void) plugin:(MapwizePlugin*) plugin didChangeFloors:(NSArray<NSNumber*>*) floors {
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

- (void) plugin:(MapwizePlugin*) plugin didTap:(MWZClickEvent*) clickEvent {
    if (isInDirection) {
        return;
    }
    switch (clickEvent.eventType) {
        case PLACE_CLICK:
            [self selectPlace:clickEvent.place centerOn:NO];
            break;
        case VENUE_CLICK:
            [_mapwizePlugin centerOnVenue:clickEvent.venue forceEntering:YES];
            break;
        default:
            [self unselectContent:YES];
            break;
    }
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
        if ([selectedContent isKindOfClass:MWZPlaceList.class]) {
            [_delegate mapwizeView:self didTapOnPlaceListInformationButton:(MWZPlaceList*)selectedContent];
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
    if (![universe.identifier isEqualToString:[_mapwizePlugin getUniverse].identifier]) {
        [_mapwizePlugin setUniverse:universe];
    }
    [self selectPlace:place centerOn:YES];
}

- (void) didSelectPlaceList:(MWZPlaceList *)placelist universe:(MWZUniverse *)universe {
    if (![universe.identifier isEqualToString:[_mapwizePlugin getUniverse].identifier]) {
        [_mapwizePlugin setUniverse:universe];
    }
    [self selectPlaceList:placelist];
}

- (void) didSelectVenue:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapwizePlugin centerOnVenue:venue forceEntering:YES];
    });
}

#pragma mark MWZComponentCompassDelegate

- (void) didPress:(MWZComponentCompass *)compass {
    [_mapwizePlugin setFollowUserMode:NONE];
    [_mapboxMap setDirection:0 animated:YES];
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
    [_mapwizePlugin removePromotedPlacesForVenue:[_mapwizePlugin getVenue]];
    [directionInfo close];
}

- (void) didStartLoading {
    [self bringSubviewToFront:loadingBar];
    [loadingBar startAnimation];
}

- (void) didStopLoading {
    [loadingBar stopAnimation];
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

#pragma mark MWZComponentUniversesButtonDelegate

- (void) didSelectUniverse:(MWZUniverse *)universe {
    if (selectedContent) {
        [self unselectContent:YES];
    }
    [self handleUniverseUpdate:universe];
    [_mapwizePlugin setUniverse:universe];
}

#pragma mark MWZComponentLanguagesButtonDelegate

- (void) didSelectLanguage:(NSString *)language {
    [_mapwizePlugin setLanguage:language forVenue:[_mapwizePlugin getVenue]];
}




@end
