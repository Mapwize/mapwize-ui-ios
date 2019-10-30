#import <UIKit/UIKit.h>
#import "MWZSearchQueryBar.h"
#import "MWZSearchViewControllerOptions.h"
#import "MWZComponentResultList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchViewController : UIViewController

@property (nonatomic) MWZSearchViewControllerOptions* searchOptions;
@property (nonatomic) MWZSearchQueryBar* searchQueryBar;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) UIView* resultContainerView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* resultContainerViewHeightConstraint;

@end

NS_ASSUME_NONNULL_END
