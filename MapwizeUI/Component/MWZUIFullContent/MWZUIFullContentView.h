#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewDelegate.h"


@class MWZPlaceDetails;
@class MWZUIFullContentViewComponentButton;
@class MWZUIFullContentViewComponentRow;
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIFullContentView : UIView

@property (nonatomic, weak) id<MWZUIFullContentViewDelegate> delegate;
@property (nonatomic) MWZPlaceDetails* placeDetails;
@property (nonatomic) UIColor* color;

-(instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color;

-(void)setContentForPlaceDetails:(MWZPlaceDetails*)placeDetails
                 language:(NSString*)language
                  buttons:(NSArray<MWZUIFullContentViewComponentButton*>*)buttons
                     rows:(NSArray<MWZUIFullContentViewComponentRow*>*)rows;

- (NSMutableArray<MWZUIFullContentViewComponentButton*>*) buildHeaderButtonsForPlaceDetails:(MWZPlaceDetails*)placeDetails
                                                                             showInfoButton:(BOOL)shouldShowInformationButton
                                                                                   language:(NSString*)language;

- (NSMutableArray<MWZUIFullContentViewComponentRow*>*) buildContentRowsForPlaceDetails:(MWZPlaceDetails*)placeDetails
                                                                              language:(NSString*)language shouldShowReportRow:(BOOL)reportRow;

@end

NS_ASSUME_NONNULL_END
