#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIPagerView : UIView

- (void) addSlide:(UIView*)slide named:(NSString*)name;
- (void) build;

@end

NS_ASSUME_NONNULL_END
