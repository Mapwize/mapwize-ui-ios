#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBar.h"
#import "MWZMapViewMenuBarDelegate.h"
#import "MWZDefaultSceneDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZDefaultScene : UIView <MWZMapViewMenuBarDelegate>

@property (nonatomic) MWZMapViewMenuBar* menuBar;

@property (nonatomic, weak) id<MWZDefaultSceneDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
