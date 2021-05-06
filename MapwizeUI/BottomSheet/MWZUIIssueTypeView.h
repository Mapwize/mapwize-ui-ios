#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIIssueTypeViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIIssueTypeView : MWZUIFullContentViewComponentRow <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UICollectionView* collectionView;
@property (nonatomic) NSLayoutConstraint* collectionViewHeight;
@property (nonatomic) NSArray<MWZIssueType*>* issueTypes;
@property (nonatomic) NSString* language;
@property (nonatomic, weak) id<MWZUIIssueTypeViewDelegate> delegate;
@property (nonatomic) UILabel* errorMessageLabel;

- (instancetype) initWithFrame:(CGRect)frame issueTypes:(NSArray<MWZIssueType*>*)issueTypes color:(UIColor*)color language:(NSString*)language;
- (void) setErrorMessage:(NSString*)message;

@end

NS_ASSUME_NONNULL_END
