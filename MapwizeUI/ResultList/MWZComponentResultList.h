#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentResultListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentResultList : UITableView

@property (nonatomic, weak) id<MWZComponentResultListDelegate> resultDelegate;

- (void) swapResults:(NSArray<id<MWZObject>>*) results withLanguage:(NSString*) language;

@end

NS_ASSUME_NONNULL_END
