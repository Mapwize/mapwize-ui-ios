#import <UIKit/UIKit.h>
@import MapwizeSDK;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBookingGridView : UIView

@property (nonatomic) UIColor* color;

- (instancetype)initWithFrame:(CGRect)frame gridWidth:(double)gridWidth color:(UIColor*)color;

- (void) setCurrentTime:(double)hours events:(NSArray<MWZPlaceDetailsEvent*>*)events;

@end

NS_ASSUME_NONNULL_END
