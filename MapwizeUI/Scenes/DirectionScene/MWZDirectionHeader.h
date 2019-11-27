#import <UIKit/UIKit.h>
#import "MWZDirectionHeaderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class MWZComponentBorderedTextField;

@interface MWZDirectionHeader : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<MWZDirectionHeaderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*) mainColor;

- (void) setButtonsHidden:(BOOL) isHidden;
- (void) openFromSearch;
- (void) closeFromSearch;
- (void) openToSearch;
- (void) closeToSearch;
-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setAccessibleMode:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
