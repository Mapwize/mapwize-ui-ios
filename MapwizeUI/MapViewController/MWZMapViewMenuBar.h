#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapViewMenuBar : UIView

@property (nonatomic) UIButton* menuButton;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UILabel* searchQueryLabel;

@property (nonatomic, weak) id<MWZMapViewMenuBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
