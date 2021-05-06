#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewComponentRow.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MWZUIReportIssueRowDelegate <NSObject>

- (void) didTapOnReportIssue;

@end

@interface MWZUIReportIssueRow : MWZUIFullContentViewComponentRow

@property (nonatomic, weak) id<MWZUIReportIssueRowDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
