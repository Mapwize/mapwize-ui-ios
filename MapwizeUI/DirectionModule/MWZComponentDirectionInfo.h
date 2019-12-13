#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentDirectionInfo : UIView

- (instancetype) initWithColor:(UIColor*) color;

- (void) showLoading;
- (void) hideLoading;
- (void) showErrorMessage:(NSString*) message;
- (void) setInfoWith:(double) directionTravelTime directionDistance:(double) directionDistance;
- (void) close;
    
@end

NS_ASSUME_NONNULL_END
