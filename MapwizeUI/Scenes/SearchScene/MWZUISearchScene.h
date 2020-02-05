#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUISearchQueryBar.h"
#import "MWZUISearchViewControllerOptions.h"
#import "MWZUIGroupedResultList.h"
#import "MWZUISearchSceneDelegate.h"
#import "MWZUIScene.h"
#import "MWZUIGroupedResultListDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUISearchScene : NSObject <MWZUIScene, MWZUISearchQueryBarDelegate, MWZUIGroupedResultListDelegate>

@property (nonatomic) MWZUISearchViewControllerOptions* searchOptions;
@property (nonatomic) MWZUISearchQueryBar* searchQueryBar;
@property (nonatomic) MWZUIGroupedResultList* resultList;
@property (nonatomic) UIView* resultContainerView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* resultContainerViewHeightConstraint;

@property (nonatomic) UIColor* mainColor;

@property (nonatomic, weak) id<MWZUISearchSceneDelegate> delegate;

- (void) clearSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language
                  forQuery:(NSString*) query;
- (void) showResults:(NSArray<id<MWZObject>> *)results withLanguage:(NSString *)language forQuery:(NSString*) query;

@end

NS_ASSUME_NONNULL_END
