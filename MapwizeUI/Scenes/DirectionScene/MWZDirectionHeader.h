#import <UIKit/UIKit.h>
#import "MWZDirectionHeaderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class MWZComponentBorderedTextField;

@interface MWZDirectionHeader : UIView

@property (nonatomic, weak) id<MWZDirectionHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
