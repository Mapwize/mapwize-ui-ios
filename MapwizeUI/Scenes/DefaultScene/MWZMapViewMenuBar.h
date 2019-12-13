#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewMenuBar : UIView

@property (nonatomic) UIButton* menuButton;
@property (nonatomic) UIActivityIndicatorView* activityIndicator;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UILabel* searchQueryLabel;

@property (nonatomic, weak) id<MWZMapViewMenuBarDelegate> delegate;

- (void) showActivityIndicator;
- (void) hideActivityIndicator;

@end

NS_ASSUME_NONNULL_END
