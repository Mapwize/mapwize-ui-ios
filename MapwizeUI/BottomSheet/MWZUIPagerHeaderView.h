#import <UIKit/UIKit.h>
#import "MWZUIPagerHeaderViewDelegate.h"

@class MWZUIPagerHeaderTitle;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIPagerHeaderView : UIView

@property (nonatomic, weak) id<MWZUIPagerHeaderViewDelegate> delegate;
@property (nonatomic) UIStackView* stackView;
@property (nonatomic) NSArray<MWZUIPagerHeaderTitle*>* titles;
@property (nonatomic) NSMutableArray<UIButton*>* buttons;
@property (nonatomic) MWZUIPagerHeaderTitle* selectedTitle;
@property (nonatomic) UIView* selectorView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;

- (instancetype) initWithColor:(UIColor*) color;
- (void) setSelectedIndex:(NSNumber*) index;

@end

NS_ASSUME_NONNULL_END
