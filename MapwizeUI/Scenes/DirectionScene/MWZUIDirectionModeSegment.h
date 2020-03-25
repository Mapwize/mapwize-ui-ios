#import <UIKit/UIKit.h>
#import "MWZUIDirectionModeSegmentDelegate.h"

@import MapwizeSDK;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIDirectionModeSegment : UIView

@property (nonatomic, weak) id<MWZUIDirectionModeSegmentDelegate> delegate;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIStackView* stackView;
@property (nonatomic) NSArray<MWZDirectionMode*>* modes;
@property (nonatomic) NSMutableArray<UIButton*>* buttons;
@property (nonatomic) MWZDirectionMode* selectedMode;
@property (nonatomic) UIView* selectorView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;

- (instancetype) initWithColor:(UIColor*) color;

@end

NS_ASSUME_NONNULL_END
