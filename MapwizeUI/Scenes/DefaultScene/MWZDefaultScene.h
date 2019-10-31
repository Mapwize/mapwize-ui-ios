#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBar.h"
#import "MWZMapViewMenuBarDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZDefaultScene : NSObject <MWZScene, MWZMapViewMenuBarDelegate>

@property (nonatomic) MWZMapViewMenuBar* menuBar;

@property (nonatomic, weak) id<MWZDefaultSceneDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
