#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWZUIDefaultScene.h"
#import "MWZUISearchScene.h"
#import "MWZUIDirectionScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUISceneCoordinator : NSObject

-(instancetype) initWithContainerView:(UIView*) containerView;

@property (nonatomic, weak) UIView* containerView;
@property (nonatomic, weak) MWZUIDefaultScene* defaultScene;
@property (nonatomic, weak) MWZUISearchScene* searchScene;
@property (nonatomic, weak) MWZUIDirectionScene* directionScene;

-(void) transitionFromDefaultToSearch;
-(void) transitionFromSearchToDefault;
-(void) transitionFromDefaultToDirection;
-(void) transitionFromDirectionToDefault;
-(void) transitionFromDirectionToSearch;
-(void) transitionFromSearchToDirection;

@end

NS_ASSUME_NONNULL_END
