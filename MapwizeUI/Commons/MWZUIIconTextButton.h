#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 MWZUIIconTextButton is used by the SDK to display button in the selected content view.
 */
@interface MWZUIIconTextButton : UIButton

/**
 Creates a MWZUIIconTextButton
 @param title displayed on the button
 @param image show on the left on the button
 @param color of the button
 @param outlined If YES, to color will be set as background color
 */
- (instancetype)initWithTitle:(NSString*) title image:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined;

@end

NS_ASSUME_NONNULL_END
