#import <UIKit/UIKit.h>
#import "MWZUIMapViewMenuBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIMapViewMenuBar : UIView

@property (nonatomic) UIButton* menuButton;
@property (nonatomic) UIActivityIndicatorView* activityIndicator;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UILabel* searchQueryLabel;

@property (nonatomic, weak) id<MWZUIMapViewMenuBarDelegate> delegate;

- (void) showActivityIndicator;
- (void) hideActivityIndicator;

@end

NS_ASSUME_NONNULL_END
