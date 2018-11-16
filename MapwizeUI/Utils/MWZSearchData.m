#import "MWZSearchData.h"

@implementation MWZSearchData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _venues = [[NSMutableArray alloc] init];
        _mainFrom = [[NSMutableArray alloc] init];
        _mainSearch = [[NSMutableArray alloc] init];
        _accessibleUniverses = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
