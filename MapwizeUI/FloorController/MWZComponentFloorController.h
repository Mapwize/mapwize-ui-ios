#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

#import "MWZComponentFloorControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentFloorController : UIScrollView

@property (nonatomic,weak) id<MWZComponentFloorControllerDelegate> floorControllerDelegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) mapwizeFloorsDidChange:(NSArray<MWZFloor*>*) floors showController:(BOOL) showController;
- (void) mapwizeFloorWillChange:(MWZFloor*) floor;
- (void) mapwizeFloorDidChange:(MWZFloor*) floor;

@end

NS_ASSUME_NONNULL_END
