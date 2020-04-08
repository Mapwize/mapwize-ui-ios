#import <UIKit/UIKit.h>

@import MapwizeSDK;

@protocol MWZUIFollowUserButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIFollowUserButton : UIButton

@property (nonatomic, weak) id<MWZUIFollowUserButtonDelegate> delegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) setFollowUserMode:(MWZFollowUserMode) mode;

@end

NS_ASSUME_NONNULL_END
