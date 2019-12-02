#import <UIKit/UIKit.h>
#import "MWZDirectionMode.h"
#import "MWZDirectionModeSegmentDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface MWZDirectionModeSegment : UIStackView

@property (nonatomic, weak) id<MWZDirectionModeSegmentDelegate> delegate;
@property (nonatomic) NSArray<MWZDirectionMode*>* modes;
@property (nonatomic) NSMutableArray<UIButton*>* buttons;
@property (nonatomic) MWZDirectionMode* selectedMode;
@property (nonatomic) UIView* selectorView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* haloColor;

- (instancetype) initWithItems:(NSArray<MWZDirectionMode*>*)modes color:(UIColor*) color;

@end

NS_ASSUME_NONNULL_END
