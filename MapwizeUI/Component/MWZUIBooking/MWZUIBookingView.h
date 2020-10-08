#import <UIKit/UIKit.h>
#import "MWZUIFullContentViewComponentRow.h"
@class MWZUIPlaceMock;
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBookingView : MWZUIFullContentViewComponentRow

@property (nonatomic) UIScrollView* scrollView;

- (instancetype) initWithFrame:(CGRect)frame mock:(MWZUIPlaceMock*)mock color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
