#import "ILIndoorLocation+DirectionPoint.h"

@implementation ILIndoorLocation (MWZDirectionPoint)
    
- (MWZDirectionWrapper *)toDirectionWrapper {
    MWZDirectionWrapper* wrapper = [[MWZDirectionWrapper alloc] init];
    wrapper.latitude = [NSNumber numberWithDouble:self.latitude];
    wrapper.longitude = [NSNumber numberWithDouble:self.longitude];
    wrapper.floor = self.floor;
    return wrapper;
}

@end
