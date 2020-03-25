#import <UIKit/UIKit.h>
#import "MWZUIDirectionHeaderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class MWZUIBorderedTextField;
@class MWZDirectionMode;

@interface MWZUIDirectionHeader : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<MWZUIDirectionHeaderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*) mainColor;

- (void) setButtonsHidden:(BOOL) isHidden;
- (void) openFromSearch;
- (void) closeFromSearch;
- (void) openToSearch;
- (void) closeToSearch;
- (void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setAvailableModes:(NSArray<MWZDirectionMode*>*) modes;
- (void) setSelectedMode:(MWZDirectionMode*) mode;

@end

NS_ASSUME_NONNULL_END
