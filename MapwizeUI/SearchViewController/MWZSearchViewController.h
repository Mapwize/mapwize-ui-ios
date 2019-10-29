#import <UIKit/UIKit.h>
#import "MWZSearchQueryBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchViewController : UIViewController

@property (nonatomic) MWZSearchQueryBar* searchQueryBar;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) NSLayoutConstraint* tableViewHeightConstraint;

@end

NS_ASSUME_NONNULL_END
