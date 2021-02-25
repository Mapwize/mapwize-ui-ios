#import <Foundation/Foundation.h>
#import "MWZUIFullContentViewComponentButton.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIIconTextButton.h"
NS_ASSUME_NONNULL_BEGIN

/**
 MWZUIBottomSheetComponents is used as container for all the content displayed in the bottomsheet.
 */
@interface MWZUIBottomSheetComponents : NSObject

/// If true, the details view won't be able to expand
@property (assign) BOOL preventExpand;
/// The list of buttons displayed in the large view
@property (nonatomic) NSMutableArray<MWZUIFullContentViewComponentButton*>* headerButtons;
/// The list of rows displayed in the large view
@property (nonatomic) NSMutableArray<MWZUIFullContentViewComponentRow*>* contentRows;
/// The list of buttons displayed in the small view
@property (nonatomic) NSMutableArray<MWZUIIconTextButton*>* minimizedViewButtons;

- (instancetype) initWithHeaderButtons:(NSMutableArray<MWZUIFullContentViewComponentButton*>*)headerButtons
                           contentRows:(NSMutableArray<MWZUIFullContentViewComponentRow*>*) contentRows
                  minimizedViewButtons:(NSMutableArray<MWZUIIconTextButton*>*) minimizedViewButtons
                         preventExpand:(BOOL)preventExpand;

@end

NS_ASSUME_NONNULL_END
