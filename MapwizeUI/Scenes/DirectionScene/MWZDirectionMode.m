#import "MWZDirectionMode.h"

@implementation MWZDirectionMode

- (instancetype) initWithImage:(UIImage*) image isAccessible:(BOOL) isAccessible {
    self = [super init];
    if (self) {
        _image = image;
        _isAccessible = isAccessible;
    }
    return self;
}

@end
