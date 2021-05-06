#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUILabelRow : UIView

@property (nonatomic) UIImage* image;
@property (nonatomic) UIColor* color;

- (instancetype) initWithImage:(UIImage*)image label:(NSString*)label color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
