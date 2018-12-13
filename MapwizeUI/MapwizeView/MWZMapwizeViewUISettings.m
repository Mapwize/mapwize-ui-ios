#import "MWZMapwizeViewUISettings.h"

@implementation MWZMapwizeViewUISettings

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainColor = [UIColor colorWithRed:197.f/255.0f green:21/255.0f blue:134/255.0f alpha:1.0f];
        _menuButtonIsHidden = NO;
        _followUserButtonIsHidden = NO;
        _floorControllerIsHidden = NO;
        _compassIsHidden = NO;
    }
    return self;
}

@end
