#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentFollowUserButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentFollowUserButton : UIButton

@property (nonatomic, weak) id<MWZComponentFollowUserButtonDelegate> delegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) setFollowUserMode:(MWZFollowUserMode) mode;

@end

NS_ASSUME_NONNULL_END
