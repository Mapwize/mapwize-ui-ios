#import <Foundation/Foundation.h>
#import "MWZDirectionHeader.h"
#import "MWZDirectionHeaderDelegate.h"
#import "MWZScene.h"
#import "MWZDirectionSceneDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface MWZDirectionScene : NSObject <MWZScene, MWZDirectionHeaderDelegate>

@property (nonatomic, weak) id<MWZDirectionSceneDelegate> delegate;
@property (nonatomic) MWZDirectionHeader* directionHeader;

@end

NS_ASSUME_NONNULL_END
