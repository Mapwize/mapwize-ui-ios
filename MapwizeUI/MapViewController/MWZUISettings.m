#import "MWZUISettings.h"

@implementation MWZUISettings

- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuButtonIsHidden = NO;
        _followUserButtonIsHidden = NO;
        _floorControllerIsHidden = NO;
        _compassIsHidden = NO;
    }
    return self;
}

@end
