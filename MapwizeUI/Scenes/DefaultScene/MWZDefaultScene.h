#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBar.h"
#import "MWZMapViewMenuBarDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZComponentBottomInfoView.h"
#import "MWZComponentBottomInfoViewDelegate.h"
#import "MWZScene.h"
#import "MWZDefaultSceneProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZDefaultScene : NSObject <MWZScene, MWZMapViewMenuBarDelegate, MWZComponentBottomInfoViewDelegate>

@property (nonatomic) MWZMapViewMenuBar* menuBar;
@property (nonatomic) MWZComponentBottomInfoView* bottomInfoView;
@property (nonatomic) UIColor* mainColor;
@property (nonatomic, weak) id<MWZDefaultSceneDelegate> delegate;
@property (nonatomic) MWZDefaultSceneProperties* sceneProperties;

@end

NS_ASSUME_NONNULL_END
