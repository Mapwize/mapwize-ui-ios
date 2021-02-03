#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewComponentRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBookingView : MWZUIFullContentViewComponentRow

@property (nonatomic) UIScrollView* scrollView;

- (instancetype) initWithFrame:(CGRect)frame placeDetails:(MWZPlaceDetails*)placeDetails color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
