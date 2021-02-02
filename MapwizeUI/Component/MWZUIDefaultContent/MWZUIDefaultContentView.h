#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIDefaultContentViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class MWZPlaceDetails;
@class MWZUIIconTextButton;

@interface MWZUIDefaultContentView : UIView

@property (nonatomic, weak) id<MWZUIDefaultContentViewDelegate> delegate;
@property (nonatomic) MWZPlaceDetails* placeDetails;
@property (nonatomic) MWZPlacePreview* placePreview;
@property (nonatomic) UIColor* color;

-(instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color;

-(NSMutableArray<MWZUIIconTextButton*>*) buildButtonsForPlaceDetails:(MWZPlaceDetails*)placeDetails showInfoButton:(BOOL)showInfoButton;
-(void)setContentForPlaceDetails:(MWZPlaceDetails*)placeDetails
                 language:(NSString*)language
                  buttons:(NSMutableArray<MWZUIIconTextButton*>*)buttons;

@end

NS_ASSUME_NONNULL_END
