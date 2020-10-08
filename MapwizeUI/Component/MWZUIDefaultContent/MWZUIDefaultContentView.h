#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIPlaceMock.h"
NS_ASSUME_NONNULL_BEGIN

@class MWZUIIconTextButton;

@interface MWZUIDefaultContentView : UIView

@property (nonatomic) MWZUIPlaceMock* mock;
@property (nonatomic) MWZPlace* place;
@property (nonatomic) MWZPlacePreview* placePreview;
@property (nonatomic) UIColor* color;

-(instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color;

-(NSMutableArray<MWZUIIconTextButton*>*) buildButtonsForPlace:(MWZPlace*)place;
-(void)setContentForPlace:(MWZPlace*)place
                 language:(NSString*)language
                  buttons:(NSMutableArray<MWZUIIconTextButton*>*)buttons;

@end

NS_ASSUME_NONNULL_END
