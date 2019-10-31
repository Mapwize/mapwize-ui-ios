#import <UIKit/UIKit.h>
#import "MWZSearchQueryBar.h"
#import "MWZSearchViewControllerOptions.h"
#import "MWZComponentResultList.h"
#import "MWZSearchSceneDelegate.h"
#import "MWZScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchScene : NSObject <MWZScene, MWZSearchQueryBarDelegate>

@property (nonatomic) MWZSearchViewControllerOptions* searchOptions;
@property (nonatomic) MWZSearchQueryBar* searchQueryBar;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) UIView* resultContainerView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* resultContainerViewHeightConstraint;

@property (nonatomic, weak) id<MWZSearchSceneDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
