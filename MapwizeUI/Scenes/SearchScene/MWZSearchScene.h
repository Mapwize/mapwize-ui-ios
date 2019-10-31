#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZSearchQueryBar.h"
#import "MWZSearchViewControllerOptions.h"
#import "MWZComponentResultList.h"
#import "MWZSearchSceneDelegate.h"
#import "MWZScene.h"
#import "MWZComponentResultListDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchScene : NSObject <MWZScene, MWZSearchQueryBarDelegate, MWZComponentResultListDelegate>

@property (nonatomic) MWZSearchViewControllerOptions* searchOptions;
@property (nonatomic) MWZSearchQueryBar* searchQueryBar;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) UIView* resultContainerView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* resultContainerViewHeightConstraint;

@property (nonatomic, weak) id<MWZSearchSceneDelegate> delegate;

- (void) clearSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results;

@end

NS_ASSUME_NONNULL_END
