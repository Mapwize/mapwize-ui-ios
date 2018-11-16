#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentLoadingBar : UIView

- (instancetype) initWithColor:(UIColor*) color;

- (void) startAnimation;
- (void) stopAnimation;
@end

NS_ASSUME_NONNULL_END
