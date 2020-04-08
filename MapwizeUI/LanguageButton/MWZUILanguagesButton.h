#import <UIKit/UIKit.h>

@import MapwizeSDK;

@protocol MWZUILanguagesButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUILanguagesButton : UIButton

@property (nonatomic, weak) id<MWZUILanguagesButtonDelegate> delegate;

- (instancetype) init;

- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidExitVenue;

@end

NS_ASSUME_NONNULL_END
