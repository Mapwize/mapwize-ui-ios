#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentLanguagesButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentLanguagesButton : UIButton

@property (nonatomic, weak) id<MWZComponentLanguagesButtonDelegate> delegate;

- (instancetype) init;

- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidExitVenue;

@end

NS_ASSUME_NONNULL_END
