#import <UIKit/UIKit.h>
#import "MWZMapViewMenuBar.h"
#import "MWZMapViewMenuBarDelegate.h"
#import "MWZDefaultSceneDelegate.h"
#import "MWZComponentBottomInfoView.h"
#import "MWZComponentBottomInfoViewDelegate.h"
#import "MWZScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZDefaultScene : NSObject <MWZScene, MWZMapViewMenuBarDelegate, MWZComponentBottomInfoViewDelegate>

@property (nonatomic) MWZMapViewMenuBar* menuBar;
@property (nonatomic) MWZComponentBottomInfoView* bottomInfoView;

@property (nonatomic, weak) id<MWZDefaultSceneDelegate> delegate;

- (void) setDirectionButtonHidden:(BOOL) isHidden;
- (void) setSearchBarTitleForVenue:(NSString*) venueName;
- (void) showContent:(id<MWZObject>) object language:(NSString*) language showInfoButton:(BOOL) showInfoButton;
- (void) hideContent;

@end

NS_ASSUME_NONNULL_END
