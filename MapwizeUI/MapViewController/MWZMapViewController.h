#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZSearchSceneDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZSceneCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewController : UIViewController
<UIViewControllerTransitioningDelegate, MWZSearchSceneDelegate,
MWZDefaultSceneDelegate, MWZDirectionSceneDelegate, MWZMapViewDelegate>

@property (nonatomic) MWZMapView* mapView;

@end

NS_ASSUME_NONNULL_END
