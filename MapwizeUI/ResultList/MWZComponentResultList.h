#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentResultListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentResultList : UITableView

@property (nonatomic, weak) id<MWZComponentResultListDelegate> resultDelegate;

- (void) setLanguage:(NSString*) language;
- (void) swapResults:(NSArray<id<MWZObject>>*) results;

@end

NS_ASSUME_NONNULL_END
