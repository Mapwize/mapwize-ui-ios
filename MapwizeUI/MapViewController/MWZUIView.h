#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
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
#import "MWZUIOptions.h"
#import "MWZUISettings.h"

@class MWZUIFollowUserButton;
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIView : UIView
<UIViewControllerTransitioningDelegate, MWZUISearchSceneDelegate,
MWZUIDefaultSceneDelegate, MWZUIDirectionSceneDelegate, MWZMapViewDelegate,
MWZUIFloorControllerDelegate, MWZUICompassDelegate,
MWZUIFollowUserButtonDelegate, MGLMapViewDelegate,
MWZUIUniversesButtonDelegate,MWZUILanguagesButtonDelegate>

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

- (void) selectPlace:(MWZPlace*) place;

- (void) selectPlaceList:(MWZPlacelist*) placeList;

- (void) unselectContent;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;


@end

NS_ASSUME_NONNULL_END
