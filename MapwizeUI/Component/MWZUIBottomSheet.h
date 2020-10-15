#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIBottomSheetDelegate.h"
#import "MWZUIDefaultContentViewDelegate.h"
#import "MWZUIFullContentViewDelegate.h"

@class MWZUIPlaceMock;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBottomSheet : UIView <MWZUIDefaultContentViewDelegate, MWZUIFullContentViewDelegate>

@property (nonatomic,weak) id<MWZUIBottomSheetDelegate> delegate;

- (instancetype)initWithFrame:(CGRect) frame color:(UIColor*)color;

- (void) showPlacePreview:(MWZPlacePreview*)placePreview;
- (void) showPlace:(MWZPlace*)place language:(NSString*)language;
- (void) removeContent;

@end

NS_ASSUME_NONNULL_END
