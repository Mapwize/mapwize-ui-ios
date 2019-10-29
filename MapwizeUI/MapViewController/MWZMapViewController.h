#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZMapViewMenuBar.h"
#import "MWZMapViewMenuBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewController : UIViewController <UIViewControllerTransitioningDelegate, MWZMapViewMenuBarDelegate>

@property (nonatomic) MWZMapView* mapView;
@property (nonatomic) MWZMapViewMenuBar* menuBar;

@end

NS_ASSUME_NONNULL_END
