#import <UIKit/UIKit.h>
#import "MWZUIMapViewMenuBar.h"
#import "MWZUIMapViewMenuBarDelegate.h"
#import "MWZUIDefaultSceneDelegate.h"
#import "MWZUIBottomInfoView.h"
#import "MWZUIBottomInfoViewDelegate.h"
#import "MWZUIScene.h"
#import "MWZUIDefaultSceneProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIDefaultScene : NSObject <MWZUIScene, MWZUIMapViewMenuBarDelegate, MWZUIBottomInfoViewDelegate>

- (instancetype) initWith:(UIColor*) mainColor menuIsHidden:(BOOL) menuIsHidden;

@property (nonatomic) MWZUIMapViewMenuBar* menuBar;
@property (nonatomic) MWZUIBottomInfoView* bottomInfoView;
@property (nonatomic) UIColor* mainColor;
@property (assign) BOOL menuIsHidden;
@property (nonatomic, weak) id<MWZUIDefaultSceneDelegate> delegate;
@property (nonatomic) MWZUIDefaultSceneProperties* sceneProperties;

@end

NS_ASSUME_NONNULL_END
