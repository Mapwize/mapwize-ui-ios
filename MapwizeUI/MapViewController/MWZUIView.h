#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
@protocol MWZUIViewDelegate;
@protocol MWZUISearchSceneDelegate;
@protocol MWZUIDefaultSceneDelegate;
@protocol MWZUIDirectionSceneDelegate;
@protocol MWZUIFloorControllerDelegate;
@protocol MWZUICompassDelegate;
@protocol MWZUIFollowUserButtonDelegate;
@protocol MWZUILanguagesButtonDelegate;
@protocol MWZUIUniversesButtonDelegate;

@class MWZUISceneCoordinator;

@class MWZUISettings;
@class MWZUIOptions;
@class MWZUIFollowUserButton;
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIView : UIView

@property (nonatomic) MWZMapView* mapView;
@property (nonatomic, weak) id<MWZUIViewDelegate> delegate;
@property (nonatomic) MWZUIFollowUserButton* followUserButton;

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZUISettings*) uiSettings;

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZUISettings*) uiSettings;

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;

- (void) selectPlaceList:(MWZPlacelist*) placeList;

- (void) unselectContent;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;


@end

NS_ASSUME_NONNULL_END
