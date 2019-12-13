#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZMapViewControllerDelegate.h"
#import "MWZSearchSceneDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZSceneCoordinator.h"
#import "MWZComponentFloorControllerDelegate.h"
#import "MWZComponentCompassDelegate.h"
#import "MWZComponentFollowUserButtonDelegate.h"
#import "MWZComponentLanguagesButtonDelegate.h"
#import "MWZComponentUniversesButtonDelegate.h"
#import "MWZUIOptions.h"
#import "MWZMapwizeViewUISettings.h"

@class MWZComponentFollowUserButton;
NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewController : UIView
<UIViewControllerTransitioningDelegate, MWZSearchSceneDelegate,
MWZDefaultSceneDelegate, MWZDirectionSceneDelegate, MWZMapViewDelegate,
MWZComponentFloorControllerDelegate, MWZComponentCompassDelegate,
MWZComponentFollowUserButtonDelegate, MGLMapViewDelegate,
MWZComponentUniversesButtonDelegate,MWZComponentLanguagesButtonDelegate>

@property (nonatomic) MWZMapView* mapView;
@property (nonatomic, weak) id<MWZMapViewControllerDelegate> delegate;
@property (nonatomic) MWZComponentFollowUserButton* followUserButton;

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

- (void) selectPlace:(MWZPlace*) place;

- (void) selectPlaceList:(MWZPlacelist*) placeList;

- (void) unselectContent;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;


@end

NS_ASSUME_NONNULL_END
