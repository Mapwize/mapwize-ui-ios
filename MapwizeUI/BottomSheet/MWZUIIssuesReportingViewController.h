#import <UIKit/UIKit.h>
@import MapwizeSDK;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIIssuesReportingViewController : UIViewController

- (instancetype) initWithVenue:(MWZVenue*)venue
                  placeDetails:(MWZPlaceDetails*)placeDetails
                      userInfo:(MWZUserInfo*)userInfo
                      language:(NSString*)language
                         color:(UIColor*)color
                           api:(id<MWZMapwizeApi>)api;

@end

NS_ASSUME_NONNULL_END
