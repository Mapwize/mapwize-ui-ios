#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentBottomInfoViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentBottomInfoView : UIView

@property (nonatomic, weak) id<MWZComponentBottomInfoViewDelegate> delegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) selectContentWithPlace:(MWZPlace*) place language:(NSString*) language showInfoButton:(BOOL) showInfoButton;
- (void) selectContentWithPlaceList:(MWZPlacelist*) placeList language:(NSString*) language showInfoButton:(BOOL) showInfoButton;

- (void) unselectContent;

@end

NS_ASSUME_NONNULL_END
