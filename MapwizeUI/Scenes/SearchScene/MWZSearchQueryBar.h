#import <UIKit/UIKit.h>
#import "MWZSearchQueryBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchQueryBar : UIView <UITextFieldDelegate>

@property (nonatomic) UIButton* backButton;
@property (nonatomic) UIButton* clearButton;
@property (nonatomic) UITextField* searchTextField;

@property (nonatomic, weak) id<MWZSearchQueryBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
