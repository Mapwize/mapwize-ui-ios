#import <UIKit/UIKit.h>
#import "MWZUISearchQueryBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUISearchQueryBar : UIView <UITextFieldDelegate>

@property (nonatomic) UIButton* backButton;
@property (nonatomic) UIButton* clearButton;
@property (nonatomic) UITextField* searchTextField;

@property (nonatomic, weak) id<MWZUISearchQueryBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
