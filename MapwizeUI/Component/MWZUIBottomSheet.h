#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIBottomSheetDelegate.h"
#import "MWZUIDefaultContentViewDelegate.h"
#import "MWZUIFullContentViewDelegate.h"

@class MWZPlaceDetails;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBottomSheet : UIView <MWZUIDefaultContentViewDelegate, MWZUIFullContentViewDelegate>

@property (nonatomic,weak) id<MWZUIBottomSheetDelegate> delegate;

- (instancetype)initWithFrame:(CGRect) frame color:(UIColor*)color;

- (void) showPlacePreview:(MWZPlacePreview*)placePreview;
- (void) showPlaceDetails:(MWZPlaceDetails*)placeDetails
shouldShowInformationButton:(BOOL) shouldShowInformationButton
      shouldShowReportRow:(BOOL) shouldShowReportRow
                 language:(NSString*)language;
- (void) showPlacelist:(MWZPlacelist*)placelist shouldShowInformationButton:(BOOL) shouldShowInformationButton
              language:(NSString*)language;
- (void) showPlace:(MWZPlace*)place shouldShowInformationButton:(BOOL) shouldShowInformationButton language:(NSString*)language;
- (void) removeContent;

- (void) viewDidLayoutSubviews;

@end

NS_ASSUME_NONNULL_END
