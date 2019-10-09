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

@property (nonatomic) NSLayoutConstraint* followUserButtonBottomConstraint;
@property (nonatomic) NSLayoutConstraint* followUserButtonHeightConstraint;
@property (nonatomic) NSLayoutConstraint* followUserButtonWidthConstraint;
@property (nonatomic) NSLayoutConstraint* followUserButtonRightConstraint;
@property (nonatomic) NSLayoutConstraint* searchBarTopConstraint;
@property (nonatomic) NSLayoutConstraint* universesButtonLeftConstraint;

@property (nonatomic) MWZMapwizeViewUISettings* uiSettings;

@property (nonatomic) MWZSearchData* searchData;
@property (nonatomic) id<MWZObject> selectedContent;

@property (assign) BOOL isInDirection;

@end

const CGFloat marginTop = 0;
const CGFloat marginLeft = 16;
const CGFloat marginBottom = 40;
const CGFloat marginRight = 16;

@implementation MWZMapwizeView

- (instancetype) initWithFrame:(CGRect)frame mapwizeOptions:(MWZUIOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeWithFrame:frame mapwizeConfiguration:[MWZMapwizeConfiguration sharedInstance] options:options uiSettings:uiSettings];
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

- (void) initializeWithFrame:(CGRect) frame
        mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                     options:(MWZOptions*) options
                  uiSettings:(MWZMapwizeViewUISettings*) uiSettings {
    _isInDirection = NO;
    _searchData = [[MWZSearchData alloc] init];
    _uiSettings = uiSettings;
    _mapView = [[MWZMapView alloc] initWithFrame:frame options:options mapwizeConfiguration:mapwizeConfiguration];
    _mapView.delegate = self;
    _mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _mapView.mapboxDelegate = self;
    [self addSubview:self.mapView];
    
    id<MWZMapwizeApi> mapwizeApi = [MWZMapwizeApiFactory getApiWithMapwizeConfiguration:mapwizeConfiguration];
    [self instantiateUIComponents:uiSettings mapwizeApi:mapwizeApi];
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
    self.loadingBar = [[MWZComponentLoadingBar alloc] initWithColor:settings.mainColor];
    self.loadingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.loadingBar];
    
    self.floorController = [[MWZComponentFloorController alloc] initWithColor:_mapView.mapOptions.mainColor];
    self.floorController.translatesAutoresizingMaskIntoConstraints = NO;
    self.floorController.showsVerticalScrollIndicator = NO;
    self.floorController.floorControllerDelegate = self;
    [self addSubview:self.floorController];
    
    if (!self.uiSettings.compassIsHidden) {
        self.compassView = [[MWZComponentCompass alloc] initWithImage:[UIImage imageNamed:@"compass" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
        self.compassView.translatesAutoresizingMaskIntoConstraints = NO;
        self.compassView.delegate = self;
        [self addSubview:self.compassView];
    }
    
    self.followUserButton = [[MWZComponentFollowUserButton alloc] initWithColor:settings.mainColor];
    self.followUserButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.followUserButton.delegate = self;
    [self addSubview:self.followUserButton];
    
    self.languagesButton = [[MWZComponentLanguagesButton alloc] init];
    self.languagesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.languagesButton.delegate = self;
    [self addSubview:self.languagesButton];
    
    self.universesButton = [[MWZComponentUniversesButton alloc] init];
    self.universesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.universesButton.delegate = self;
    [self addSubview:self.universesButton];
    
    self.searchBar = [[MWZComponentSearchBar alloc] initWith:self.searchData uiSettings:self.uiSettings mapwizeApi:mapwizeApi];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.delegate = self;
    [self addSubview:self.searchBar];
    
    self.directionBar = [[MWZComponentDirectionBar alloc] initWithMapwizeApi:mapwizeApi searchData:self.searchData color:settings.mainColor];
    self.directionBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionBar.delegate = self;
    [self addSubview:self.directionBar];
    
    self.bottomInfoView = [[MWZComponentBottomInfoView alloc] initWithColor:self.uiSettings.mainColor];
    self.bottomInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomInfoView.delegate = self;
    [self addSubview:self.bottomInfoView];
    
}

- (void) setupConstraintsToLoadingBar:(MWZMapwizeViewUISettings*) settings {
    [[NSLayoutConstraint constraintWithItem:self.loadingBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.loadingBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:10.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.loadingBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self.searchBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:2.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.loadingBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self.directionBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:2.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.loadingBar
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:3.0f] setActive:YES];
}

- (void) setupConstraintsToDirectionBar:(MWZMapwizeViewUISettings*) settings {
    [[NSLayoutConstraint constraintWithItem:self.directionBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionBar
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    self.directionInfo = [[MWZComponentDirectionInfo alloc] initWithColor:settings.mainColor];
    self.directionInfo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.directionInfo];
    [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:self.directionInfo
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

- (void) showDirectionUI {
    [self.directionBar setTo:(id<MWZDirectionPoint>)self.selectedContent];
    if ([self.mapView getUserLocation] && [self.mapView getUserLocation].floor) {
        [self.directionBar setFrom:[[MWZIndoorLocation alloc] initWith:[self.mapView getUserLocation]]];
    }
    [self.universesButton setHidden:YES];
    [self.languagesButton setHidden:YES];
    self.isInDirection = YES;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.searchBar.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    }];
    [self.directionBar show];
    [self.bottomInfoView unselectContent];
}

- (void) showDefaultUI {
    if (self.selectedContent) {
        if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
                [self.bottomInfoView selectContentWithPlace:(MWZPlace*) self.selectedContent
                                                   language:[self.mapView getLanguage]
                                             showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlace*) self.selectedContent]];
            }
            else {
                [self.bottomInfoView selectContentWithPlace:(MWZPlace*) self.selectedContent
                                                   language:[self.mapView getLanguage]
                                             showInfoButton:NO];
            }
        }
        if ([self.selectedContent isKindOfClass:MWZPlacelist.class]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
                [self.bottomInfoView selectContentWithPlaceList:(MWZPlacelist*) self.selectedContent
                                                       language:[self.mapView getLanguage]
                                                 showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:(MWZPlacelist*) self.selectedContent]];
            }
            else {
                [self.bottomInfoView selectContentWithPlaceList:(MWZPlacelist*) self.selectedContent
                                                       language:[self.mapView getLanguage]
                                                 showInfoButton:NO];
            }
        }
        
    }
    if ([self.mapView getVenue]) {
        [self.languagesButton mapwizeDidEnterInVenue:[self.mapView getVenue]];
        if (self.languagesButton.isHidden) {
            self.universesButtonLeftConstraint.constant = marginLeft;
        }
        else {
            self.universesButtonLeftConstraint.constant = marginLeft * 2 + 50.f;
        }
        [self.universesButton showIfNeeded];
    }
    self.isInDirection = NO;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.searchBar.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
    [self.directionBar hide];
}

- (void) setupConstraintsToFloorController:(MWZMapwizeViewUISettings*) uiSettings {
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:48.f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.floorController
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.followUserButton
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    
    if (uiSettings.compassIsHidden) {
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
    }
    
}

- (void) setupConstraintsToCompass:(MWZMapwizeViewUISettings*) uiSettings {
    if (uiSettings.compassIsHidden) {
        return;
    }
    [[NSLayoutConstraint constraintWithItem:self.compassView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:40.0] setActive:YES];
    
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
    
    NSLayoutConstraint* toSearchBarConstraint = [NSLayoutConstraint constraintWithItem:_compassView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_searchBar
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:8.0f];
    toSearchBarConstraint.priority = 999;
    [toSearchBarConstraint setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:_compassView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:_directionBar
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    
    
}

- (void) setupConstraintsToSearchBar:(MWZMapwizeViewUISettings*) uiSettings {
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    
    
}

- (void) setupConstraintsToBottomInfoView:(MWZMapwizeViewUISettings*) uiSettings {
    [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.f] setActive:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:-self.safeAreaInsets.right] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0] setActive:YES];
    }
    
    [[NSLayoutConstraint constraintWithItem:self.bottomInfoView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

- (void) setupConstraintsToFollowUserButton:(MWZMapwizeViewUISettings*) settings {
    self.followUserButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f
                                                                          constant:50.f];
    
    if (settings.followUserButtonIsHidden) {
        self.followUserButtonHeightConstraint.constant = 0.0f;
    }
    
    self.followUserButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:50.f];
    
    NSLayoutConstraint* followUserMinY = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0f
                                                                       constant:0.0f];
    followUserMinY.priority = 950;
    followUserMinY.active = YES;
    
    if (@available(iOS 11.0, *)) {
        self.followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f
                                                                             constant:-self.safeAreaInsets.right - marginRight];
        self.followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                toItem:self.safeAreaLayoutGuide
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:-marginBottom];
    } else {
        self.followUserButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f
                                                                             constant:-marginRight];
        self.followUserButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:-marginBottom];
    }
    
    self.followUserButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.followUserButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:self.directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* toBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.followUserButton
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.bottomInfoView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f
                                                                               constant:-16.0f];
    toBottomViewConstraint.priority = 800;
    [toBottomViewConstraint setActive:YES];
    
    [self.followUserButtonHeightConstraint setActive:YES];
    [self.followUserButtonWidthConstraint setActive:YES];
    [self.followUserButtonRightConstraint setActive:YES];
    [self.followUserButtonBottomConstraint setActive:YES];
}

- (void) setupConstraintsToLanguagesButton {
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
                                                                       constant:self.safeAreaInsets.left + marginLeft];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant: -marginBottom];
    }
    else {
        languagesButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:marginLeft];
        
        languagesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    
    languagesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.languagesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:self.directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* languagesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.languagesButton
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.bottomInfoView
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
                                                                           constant:marginLeft * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self.safeAreaLayoutGuide
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    else {
        self.universesButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f
                                                                           constant:marginLeft * 2 + 50.f];
        
        universesButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:-marginBottom];
    }
    
    universesButtonBottomConstraint.priority = 1000;
    
    [[NSLayoutConstraint constraintWithItem:self.universesButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:self.directionInfo
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
    NSLayoutConstraint* universesToBottomViewConstraint = [NSLayoutConstraint constraintWithItem:self.universesButton
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.bottomInfoView
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

- (void) loadVenuesInSearchData {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.query = @"";
    params.objectClass = @[@"venue"];
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        [self.searchData.venues addObjectsFromArray:searchResponse];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainSearchesInSearchData:(MWZVenue*) venue {
    [self.searchData.mainSearch removeAllObjects];
    [self.mapView.mapwizeApi getMainSearchesWithVenue:venue success:^(NSArray<id<MWZObject>> *mainSearches) {
        [self.searchData.mainSearch addObjectsFromArray:mainSearches];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadMainFromsInSearchData:(MWZVenue*) venue {
    [self.searchData.mainFrom removeAllObjects];
    [self.mapView.mapwizeApi getMainFromsWithVenue:venue success:^(NSArray<MWZPlace *> *places) {
        [self.searchData.mainFrom addObjectsFromArray:places];
    } failure:^(NSError *error) {
        // Not very important to handle error here.
    }];
}

- (void) loadAccessibleUniversesInSearchData:(NSArray<MWZUniverse*>*) accessibleUniverses {
    [self.searchData.accessibleUniverses removeAllObjects];
    [self.searchData.accessibleUniverses addObjectsFromArray:accessibleUniverses];
}

- (void) unselectContent:(BOOL) closeInfo {
    [self.mapView removeMarkers];
    [self.mapView removePromotedPlaces];
    self.selectedContent = nil;
    if (closeInfo) {
        [self.bottomInfoView unselectContent];
    }
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview centerOn:(BOOL) centerOn {
    [self unselectContent:NO];
    [self.mapView addMarkerOnCoordinate:placePreview.defaultCenterCoordinate];
    if (centerOn) {
        [self.mapView centerOnPlacePreview:placePreview animated:true];
    }
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self.mapView addPromotedPlace:place];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
            [self.bottomInfoView selectContentWithPlace:place
                                               language:[self.mapView getLanguage]
                                         showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:place]];
        }
        else {
            [self.bottomInfoView selectContentWithPlace:place
                                               language:[self.mapView getLanguage]
                                         showInfoButton:NO];
        }
        
        self.selectedContent = place;
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn {
    [self unselectContent:NO];
    if (centerOn) {
        [self.mapView centerOnPlace:place animated:YES];
    }
    [self.mapView addMarkerOnPlace:place];
    [self.mapView addPromotedPlace:place];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [self.bottomInfoView selectContentWithPlace:place
                                           language:[self.mapView getLanguage]
                                     showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:place]];
    }
    else {
        [self.bottomInfoView selectContentWithPlace:place
                                           language:[self.mapView getLanguage]
                                     showInfoButton:NO];
    }
    
    self.selectedContent = place;
}

- (void) selectPlaceList:(MWZPlacelist*) placeList {
    [self unselectContent:NO];
    [self.mapView addMarkersOnPlacelist:placeList completionHandler:^(NSArray<MWZMapwizeAnnotation *> * _Nonnull handler) {
        
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapwizeView:shouldShowInformationButtonFor:)]) {
        [self.bottomInfoView selectContentWithPlaceList:placeList
                                               language:[self.mapView getLanguage]
                                         showInfoButton:[self.delegate mapwizeView:self shouldShowInformationButtonFor:placeList]];
    }
    else {
        [self.bottomInfoView selectContentWithPlaceList:placeList
                                               language:[self.mapView getLanguage]
                                         showInfoButton:NO];
    }
    self.selectedContent = placeList;
}

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    if (self.mapView) {
        [self.mapView setIndoorLocationProvider:indoorLocationProvider];
    }
}

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure {
    [self.mapView grantAccess:accessKey success:success failure:failure];
}

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible {
    self.isInDirection = YES;
    [self showDirectionUI];
    [self.directionBar setAccessibility:isAccessible];
    [self.directionBar setFrom:from];
    [self.directionBar setTo:to];
}

#pragma mark MWZMapwizePluginDelegate

- (void) mapViewDidLoad:(MWZMapView *)mapView {
    [self loadVenuesInSearchData];
    if (self.delegate) {
        [self.delegate mapwizeViewDidLoad:self];
    }
}

- (void) mapView:(MWZMapView *)mapView followUserModeDidChange:(MWZFollowUserMode)followUserMode {
    [self.followUserButton setFollowUserMode:followUserMode];
}

- (void) mapView:(MWZMapView *)mapView venueWillEnter:(MWZVenue *)venue {
    [self loadMainSearchesInSearchData:venue];
    [self loadMainFromsInSearchData:venue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchBar mapwizeWillEnterInVenue:venue];
        [self.loadingBar startAnimation];
    });
}

- (void) mapView:(MWZMapView *)mapView venueDidEnter:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchBar mapwizeDidEnterInVenue:venue];
        [self.loadingBar stopAnimation];
        [self.languagesButton mapwizeDidEnterInVenue:venue];
        if (self.languagesButton.isHidden) {
            self.universesButtonLeftConstraint.constant = marginLeft;
        }
        else {
            self.universesButtonLeftConstraint.constant = marginLeft * 2 + 50.f;
        }
        if ([self.selectedContent isKindOfClass:[MWZPlace class]]) {
            [self selectPlace:(MWZPlace*)self.selectedContent centerOn:NO];
            [self.mapView setFloor:((MWZPlace*) self.selectedContent).floor];
        }
        else if ([self.selectedContent isKindOfClass:[MWZPlacelist class]]) {
            [self selectPlaceList:(MWZPlacelist*) self.selectedContent];
        }
    });
}

- (void) mapView:(MWZMapView *)mapView venueDidExit:(MWZVenue *)venue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingBar stopAnimation];
        [self.languagesButton mapwizeDidExitVenue];
        [self.searchBar mapwizeDidExitVenue:venue];
    });
}

- (void) mapView:(MWZMapView *)mapView floorsDidChange:(NSArray<MWZFloor *> *)floors {
    if (self.uiSettings.floorControllerIsHidden) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mapwizeView:shouldShowFloorControllerFor:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.floorController mapwizeFloorsDidChange:floors
                                          showController:[self.delegate mapwizeView:self shouldShowFloorControllerFor:floors]];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.floorController mapwizeFloorsDidChange:floors
                                          showController:true];
        });
    }
}

- (void) mapView:(MWZMapView *)mapView floorDidChange:(MWZFloor *)floor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.floorController mapwizeFloorDidChange:floor];
    });
}

- (void) mapView:(MWZMapView *)mapView floorWillChange:(MWZFloor *)floor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.floorController mapwizeFloorWillChange:floor];
    });
}

- (void) mapView:(MWZMapView *)mapView didTap:(MWZClickEvent *)clickEvent {
    if (self.isInDirection) {
        if (clickEvent.eventType == MWZClickEventTypePlaceClick) {
            [clickEvent.placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.directionBar didTapOnPlace:place];
                });
            } failure:^(NSError * _Nonnull error) {
                
            }];
        }
        return;
    }
    switch (clickEvent.eventType) {
        case MWZClickEventTypePlaceClick:
            [self selectPlacePreview:clickEvent.placePreview centerOn:NO];
            break;
        case MWZClickEventTypeVenueClick:
            [self.mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
            break;
        case MWZClickEventTypeMapClick:
            [self unselectContent:YES];
            break;
    }
}

- (BOOL) mapView:(MWZMapView* _Nonnull) mapView shouldRecomputeNavigation:(MWZNavigationInfo * _Nonnull)navigationInfo {
    [self.directionInfo setInfoWith:navigationInfo.duration directionDistance:navigationInfo.distance];
    if (navigationInfo.locationDelta > 10 && navigationInfo.originalLocation && navigationInfo.originalLocation.floor) {
        return YES;
    }
    return NO;
}

- (void) mapView:(MWZMapView* _Nonnull) mapView universesDidChange:(NSArray<MWZUniverse*>* _Nonnull) accessibleUniverses {
    [self.universesButton mapwizeAccessibleUniversesDidChange: accessibleUniverses];
    [self loadAccessibleUniversesInSearchData:accessibleUniverses];
}

#pragma mark MWZComponentBottomInfoViewDelegate

- (void) didPressInformation {
    if (self.delegate) {
        if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
            [self.delegate mapwizeView:self didTapOnPlaceInformationButton:(MWZPlace*)self.selectedContent];
        }
        if ([self.selectedContent isKindOfClass:MWZPlacelist.class]) {
            [self.delegate mapwizeView:self didTapOnPlaceListInformationButton:(MWZPlacelist*)self.selectedContent];
        }
    }
}

#pragma mark MWZComponentSearchBarDelegate

- (void) didPressDirection {
    [self showDirectionUI];
}

- (void) didPressMenu {
    if (self.delegate) {
        [self.delegate mapwizeViewDidTapOnMenu:self];
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
    [self.mapView setFollowUserMode:MWZFollowUserModeNone];
    [self.mapView.mapboxMapView setDirection:0 animated:YES];
}

#pragma mark MWZComponentDirectionBarDelegate

- (void) didPressBack {
    [self showDefaultUI];
}

- (void) didUpdateDirectionInfo:(double) travelTime distance:(double) distance {
    [self unselectContent:YES];
    [self.directionInfo setInfoWith:travelTime directionDistance:distance];
}

- (void) didStopDirection {
    [self.mapView removeDirection];
    [self.mapView removePromotedPlaces];
    [self.mapView stopNavigation];
    [self.directionInfo close];
}

- (void) didStartLoading {
    [self bringSubviewToFront:self.loadingBar];
    [self.loadingBar startAnimation];
}

- (void) didStopLoading {
    [self.loadingBar stopAnimation];
}

- (void) startNavigation:(MWZDirection *)direction
                    from:(id<MWZDirectionPoint>)from
                      to:(id<MWZDirectionPoint>)to
        directionOptions:(MWZDirectionOptions*)directionOptions
            isAccessible:(BOOL)isAccessible {
    [self.mapView startNavigation:to isAccessible:isAccessible options:directionOptions];
}

- (void)didFindDirection:(MWZDirection *)direction from:(id<MWZDirectionPoint>)from to:(id<MWZDirectionPoint>)to isAccessible:(BOOL) isAccessible {
    [self unselectContent:YES];
    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
    options.centerOnStart = YES;
    options.displayEndMarker = YES;
    if ([from isKindOfClass:MWZIndoorLocation.class] && [self.mapView getUserLocation] && [self.mapView getUserLocation].floor) {
        MWZIndoorLocation* newFrom = [[MWZIndoorLocation alloc] initWith:[self.mapView getUserLocation]];
        [self startNavigation:direction from:newFrom to:to directionOptions:options isAccessible:isAccessible];
    }
    else {
        [self.mapView setFollowUserMode:MWZFollowUserModeNone];
        [self.mapView setDirection:direction options:options];
        [self.directionInfo setInfoWith:direction.traveltime directionDistance:direction.distance];
    }
    
    [self.mapView removeMarkers];
    [self.mapView removePromotedPlaces];
    if ([to isKindOfClass:MWZPlace.class]) {
        [self.mapView addPromotedPlace:(MWZPlace*) to];
    }
    if ([from isKindOfClass:MWZPlace.class]) {
        [self.mapView addPromotedPlace:(MWZPlace*) from];
    }
}

#pragma mark MGLMapViewDelegate

- (void)mapView:(MGLMapView *)mapView regionIsChangingWithReason:(MGLCameraChangeReason)reason {
    [self.compassView updateCompass:mapView.direction];
}

- (void) mapViewRegionIsChanging:(MGLMapView *)mapView {
    [self.compassView updateCompass:mapView.direction];
}

- (void) mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.compassView updateCompass:mapView.direction];
}

#pragma mark MWZComponentFollowUserButtonDelegate

- (void) didTapWithoutLocation {
    if (self.delegate) {
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


#pragma mark MWZComponentUniversesButtonDelegate

- (void) didSelectUniverse:(MWZUniverse *)universe {
    if (self.selectedContent) {
        [self unselectContent:YES];
    }
    [self.mapView setUniverse:universe];
}

#pragma mark MWZComponentLanguagesButtonDelegate

- (void) didSelectLanguage:(NSString *)language {
    [self.mapView setLanguage:language forVenue:[self.mapView getVenue]];
}

- (void)floorController:(MWZComponentFloorController *)floorController didSelect:(NSNumber *)floorOrder {
    [self.mapView setFloor:floorOrder];
}

- (NSString *)componentRequiresCurrentLanguage:(id)component {
    return [self.mapView getLanguage];
}

- (MWZUniverse *)componentRequiresCurrentUniverse:(id)component {
    return [self.mapView getUniverse];
}

- (MWZVenue *)componentRequiresCurrentVenue:(id)component {
    return [self.mapView getVenue];
}

- (ILIndoorLocation *)componentRequiresUserLocation:(id)component {
    return [self.mapView getUserLocation];
}

@end
