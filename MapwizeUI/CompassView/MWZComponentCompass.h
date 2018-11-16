#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MWZComponentCompassDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentCompass : UIImageView

@property (nonatomic, weak) id<MWZComponentCompassDelegate> delegate;

- (void) updateCompass:(CLLocationDirection) direction;

@end

NS_ASSUME_NONNULL_END
