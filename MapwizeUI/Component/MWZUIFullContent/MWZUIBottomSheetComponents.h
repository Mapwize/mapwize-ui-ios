#import <Foundation/Foundation.h>
#import "MWZUIFullContentViewComponentButton.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIIconTextButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBottomSheetComponents : NSObject

@property (nonatomic) NSMutableArray<MWZUIFullContentViewComponentButton*>* headerButtons;
@property (nonatomic) NSMutableArray<MWZUIFullContentViewComponentRow*>* contentRows;
@property (nonatomic) NSMutableArray<MWZUIIconTextButton*>* minimizedViewButtons;

- (instancetype) initWithHeaderButtons:(NSMutableArray<MWZUIFullContentViewComponentButton*>*)headerButtons
                           contentRows:(NSMutableArray<MWZUIFullContentViewComponentRow*>*) contentRows
                  minimizedViewButtons:(NSMutableArray<MWZUIIconTextButton*>*) minimizedViewButtons;

@end

NS_ASSUME_NONNULL_END
