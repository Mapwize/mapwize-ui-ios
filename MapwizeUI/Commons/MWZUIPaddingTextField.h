#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIPaddingTextField : UITextField

@property (nonatomic, assign) int topInset;
@property (nonatomic, assign) int bottomInset;
@property (nonatomic, assign) int leftInset;
@property (nonatomic, assign) int rightInset;

@end

NS_ASSUME_NONNULL_END
