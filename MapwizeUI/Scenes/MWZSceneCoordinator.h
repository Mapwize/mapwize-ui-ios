#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWZDefaultScene.h"
#import "MWZSearchScene.h"
#import "MWZDirectionScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSceneCoordinator : NSObject

-(instancetype) initWithContainerView:(UIView*) containerView;

@property (nonatomic, weak) UIView* containerView;
@property (nonatomic, weak) MWZDefaultScene* defaultScene;
@property (nonatomic, weak) MWZSearchScene* searchScene;
@property (nonatomic, weak) MWZDirectionScene* directionScene;

-(void) transitionFromDefaultToSearch;
-(void) transitionFromSearchToDefault;
-(void) transitionFromDefaultToDirection;
-(void) transitionFromDirectionToDefault;

@end

NS_ASSUME_NONNULL_END
