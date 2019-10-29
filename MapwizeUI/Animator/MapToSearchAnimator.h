#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapToSearchAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign) double duration;
@property (assign) BOOL presenting;

@end

NS_ASSUME_NONNULL_END
