#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZSearchQueryBar.h"
#import "MWZSearchViewControllerOptions.h"
#import "MWZComponentGroupedResultList.h"
#import "MWZSearchSceneDelegate.h"
#import "MWZScene.h"
#import "MWZComponentGroupedResultListDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchScene : NSObject <MWZScene, MWZSearchQueryBarDelegate, MWZComponentGroupedResultListDelegate>

@property (nonatomic) MWZSearchViewControllerOptions* searchOptions;
@property (nonatomic) MWZSearchQueryBar* searchQueryBar;
@property (nonatomic) MWZComponentGroupedResultList* resultList;
@property (nonatomic) UIView* resultContainerView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* resultContainerViewHeightConstraint;

@property (nonatomic) UIColor* mainColor;

@property (nonatomic, weak) id<MWZSearchSceneDelegate> delegate;

- (void) clearSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language;
- (void) showResults:(NSArray<id<MWZObject>> *)results withLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
