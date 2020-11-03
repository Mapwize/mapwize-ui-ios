#import <UIKit/UIKit.h>

@import MapwizeSDK;

@protocol MWZUIBottomInfoViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBottomInfoView : UIView

@property (nonatomic, weak) id<MWZUIBottomInfoViewDelegate> delegate;

- (instancetype) initWithColor:(UIColor*) color;

- (void) selectContentWithPlace:(MWZPlace*) place language:(NSString*) language showInfoButton:(BOOL) showInfoButton;
- (void) selectContentWithPlacePreview:(MWZPlacePreview*) placePreview;
- (void) selectContentWithPlaceList:(MWZPlacelist*) placeList language:(NSString*) language showInfoButton:(BOOL) showInfoButton;

- (void) unselectContent;

@end

NS_ASSUME_NONNULL_END
