#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentGroupedResultListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentGroupedResultList : UITableView

@property (nonatomic, weak) id<MWZComponentGroupedResultListDelegate> resultDelegate;

- (void) setLanguage:(NSString*) language;
- (void) swapResults:(NSArray<id<MWZObject>>*) results universes:(NSArray<MWZUniverse*>*) universes activeUniverse:(MWZUniverse*) activeUniverse;

@end

NS_ASSUME_NONNULL_END
