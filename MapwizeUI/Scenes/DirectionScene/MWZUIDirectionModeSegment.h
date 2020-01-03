#import <UIKit/UIKit.h>
#import "MWZUIDirectionMode.h"
#import "MWZUIDirectionModeSegmentDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIDirectionModeSegment : UIStackView

@property (nonatomic, weak) id<MWZUIDirectionModeSegmentDelegate> delegate;
@property (nonatomic) NSArray<MWZUIDirectionMode*>* modes;
@property (nonatomic) NSMutableArray<UIButton*>* buttons;
@property (nonatomic) MWZUIDirectionMode* selectedMode;
@property (nonatomic) UIView* selectorView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;

- (instancetype) initWithItems:(NSArray<MWZUIDirectionMode*>*)modes color:(UIColor*) color;

@end

NS_ASSUME_NONNULL_END
