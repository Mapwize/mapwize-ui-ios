#import "MWZUIBottomSheetComponents.h"

@implementation MWZUIBottomSheetComponents

- (instancetype) initWithHeaderButtons:(NSMutableArray<MWZUIFullContentViewComponentButton*>*)headerButtons contentRows:(NSMutableArray<MWZUIFullContentViewComponentRow*>*) contentRows minimizedViewButtons:(NSMutableArray<MWZUIIconTextButton*>*) minimizedViewButtons {
    self = [super init];
    if (self) {
        _headerButtons = headerButtons;
        _contentRows = contentRows;
        _minimizedViewButtons = minimizedViewButtons;
    }
    return self;
}

@end
