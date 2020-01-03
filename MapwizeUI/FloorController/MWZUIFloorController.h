#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

#import "MWZUIFloorControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIFloorController : UIScrollView

@property (nonatomic,weak) id<MWZUIFloorControllerDelegate> floorControllerDelegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) mapwizeFloorsDidChange:(NSArray<MWZFloor*>*) floors showController:(BOOL) showController;
- (void) mapwizeFloorWillChange:(MWZFloor*) floor;
- (void) mapwizeFloorDidChange:(MWZFloor*) floor;

@end

NS_ASSUME_NONNULL_END
