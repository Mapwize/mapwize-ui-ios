#import "MWZUIBottomSheetComponents.h"

@implementation MWZUIBottomSheetComponents

- (instancetype) initWithHeaderButtons:(NSMutableArray<MWZUIFullContentViewComponentButton*>*)headerButtons contentRows:(NSMutableArray<MWZUIFullContentViewComponentRow*>*) contentRows minimizedViewButtons:(NSMutableArray<MWZUIIconTextButton*>*) minimizedViewButtons preventExpand:(BOOL)preventExpand {
    self = [super init];
    if (self) {
        _headerButtons = headerButtons;
        _contentRows = contentRows;
        _minimizedViewButtons = minimizedViewButtons;
        _preventExpand = preventExpand;
    }
    return self;
}

@end
