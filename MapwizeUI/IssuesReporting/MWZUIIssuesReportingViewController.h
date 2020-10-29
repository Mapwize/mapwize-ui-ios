#import <UIKit/UIKit.h>
@import MapwizeSDK;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIIssuesReportingViewController : UIViewController

- (instancetype) initWithVenue:(MWZVenue*)venue place:(MWZPlace*)place userInfo:(MWZUserInfo*)userInfo color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
