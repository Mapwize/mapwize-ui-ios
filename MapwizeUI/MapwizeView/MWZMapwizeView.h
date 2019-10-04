#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeSDK/MapwizeSDK.h>
@protocol MWZMapwizeViewDelegate;
@class MWZMapwizeViewUISettings;
@class MWZUIOptions;
@class MWZComponentFollowUserButton;
@class MWZComponentBottomInfoView;
@class MWZComponentCompass;
@class MWZComponentSearchBar;
@class MWZComponentFloorController;
@class MWZComponentDirectionBar;
@class MWZComponentDirectionInfo;
@class MWZComponentLoadingBar;
@class MWZComponentUniversesButton;
@class MWZComponentLanguagesButton;
NS_ASSUME_NONNULL_BEGIN

@interface MWZMapwizeView : UIView

@property (nonatomic) MWZMapView* mapView;
@property (nonatomic, weak) id<MWZMapwizeViewDelegate> delegate;
@property (nonatomic) MWZComponentFollowUserButton* followUserButton;
@property (nonatomic) MWZComponentBottomInfoView* bottomInfoView;
@property (nonatomic) MWZComponentCompass* compassView;
@property (nonatomic) MWZComponentSearchBar* searchBar;
@property (nonatomic) MWZComponentFloorController* floorController;
@property (nonatomic) MWZComponentDirectionBar* directionBar;
@property (nonatomic) MWZComponentDirectionInfo* directionInfo;
@property (nonatomic) MWZComponentLoadingBar* loadingBar;
@property (nonatomic) MWZComponentUniversesButton* universesButton;
@property (nonatomic) MWZComponentLanguagesButton* languagesButton;

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;

- (void) selectPlaceList:(MWZPlacelist*) placeList;

- (void) unselectContent:(BOOL) closeInfo;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
