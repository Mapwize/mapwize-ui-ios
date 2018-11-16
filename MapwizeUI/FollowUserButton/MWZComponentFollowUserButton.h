#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentFollowUserButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentFollowUserButton : UIButton

@property (nonatomic, weak) id<MWZComponentFollowUserButtonDelegate> delegate;
@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;

- (instancetype) initWithColor:(UIColor*) color;

- (void) setFollowUserMode:(FollowUserMode) mode;

@end

NS_ASSUME_NONNULL_END
