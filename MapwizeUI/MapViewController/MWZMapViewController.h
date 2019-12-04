#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZSearchSceneDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZSceneCoordinator.h"
#import "MWZComponentFloorControllerDelegate.h"
#import "MWZComponentCompassDelegate.h"
#import "MWZComponentFollowUserButtonDelegate.h"
#import "MWZComponentLanguagesButtonDelegate.h"
#import "MWZComponentUniversesButtonDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewController : UIViewController
<UIViewControllerTransitioningDelegate, MWZSearchSceneDelegate,
MWZDefaultSceneDelegate, MWZDirectionSceneDelegate, MWZMapViewDelegate,
MWZComponentFloorControllerDelegate, MWZComponentCompassDelegate,
MWZComponentFollowUserButtonDelegate, MGLMapViewDelegate,
MWZComponentUniversesButtonDelegate,MWZComponentLanguagesButtonDelegate>

@property (nonatomic) MWZMapView* mapView;

@end

NS_ASSUME_NONNULL_END
