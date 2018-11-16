#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentDirectionInfo : UIView

- (instancetype) initWithColor:(UIColor*) color;

- (void) setInfoWith:(MWZDirection*) direction;
- (void) close;
    
@end

NS_ASSUME_NONNULL_END
