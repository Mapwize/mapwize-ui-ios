#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZUIFullContentViewDelegate.h"

@class MWZUIPlaceMock;
@class MWZUIFullContentViewComponentButton;
@class MWZUIFullContentViewComponentRow;
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIFullContentView : UIView

@property (nonatomic, weak) id<MWZUIFullContentViewDelegate> delegate;
@property (nonatomic) MWZUIPlaceMock* mock;
@property (nonatomic) MWZPlace* place;
@property (nonatomic) UIColor* color;

-(instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color;

-(void)setContentForPlace:(MWZPlace*)place
                 language:(NSString*)language
                  buttons:(NSArray<MWZUIFullContentViewComponentButton*>*)buttons
                     rows:(NSArray<MWZUIFullContentViewComponentRow*>*)rows;

- (NSMutableArray<MWZUIFullContentViewComponentButton*>*) buildHeaderButtonsForPlace:(MWZPlace*)place language:(NSString*)language;
- (NSMutableArray<MWZUIFullContentViewComponentRow*>*) buildContentRowsForPlace:(MWZPlace*)place language:(NSString*)language;

@end

NS_ASSUME_NONNULL_END
