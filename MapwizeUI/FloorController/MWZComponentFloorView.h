#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentFloorView : UILabel

@property (nonatomic) NSNumber* floor;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic) UIColor* mainColor;

- (instancetype) initWithFrame:(CGRect) frame
                withIsSelected:(BOOL) isSelected
                     mainColor:(UIColor*) mainColor;

- (void) setPreselected:(BOOL) preselected;

@end

NS_ASSUME_NONNULL_END
