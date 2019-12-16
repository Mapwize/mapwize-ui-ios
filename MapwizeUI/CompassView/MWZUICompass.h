#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MWZUICompassDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUICompass : UIImageView

@property (nonatomic, weak) id<MWZUICompassDelegate> delegate;

- (void) updateCompass:(CLLocationDirection) direction;

@end

NS_ASSUME_NONNULL_END
