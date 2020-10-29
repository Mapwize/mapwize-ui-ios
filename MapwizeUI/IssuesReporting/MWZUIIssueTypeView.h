#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewComponentRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIIssueTypeView : MWZUIFullContentViewComponentRow <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UICollectionView* collectionView;
@property (nonatomic) NSLayoutConstraint* collectionViewHeight;
@property (nonatomic) NSArray<NSString*>* issueTypes;

- (instancetype) initWithFrame:(CGRect)frame issueTypes:(NSArray<NSString*>*)issueTypes color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
