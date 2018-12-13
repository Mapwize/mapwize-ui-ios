#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentFloorController : UIScrollView

@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;

- (void) mapwizeFloorsDidChange:(NSArray<NSNumber*>*) floors showController:(BOOL) showController;
- (void) mapwizeFloorDidChange:(NSNumber*) floor;

@end

NS_ASSUME_NONNULL_END
