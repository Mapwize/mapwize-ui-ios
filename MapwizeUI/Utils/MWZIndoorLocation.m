#import "MWZIndoorLocation.h"

@implementation MWZIndoorLocation

- (instancetype) initWith:(ILIndoorLocation*) indoorLocation {
    self = [super init];
    if (self) {
        self.providerName = indoorLocation.providerName;
        self.latitude = indoorLocation.latitude;
        self.longitude = indoorLocation.longitude;
        self.floor = indoorLocation.floor;
        self.accuracy = indoorLocation.accuracy;
        self.timestamp = indoorLocation.timestamp;
    }
    return self;
}
    
- (MWZDirectionWrapper *)toDirectionWrapper {
    MWZDirectionWrapper* wrapper = [[MWZDirectionWrapper alloc] init];
    wrapper.latitude = [NSNumber numberWithDouble:self.latitude];
    wrapper.longitude = [NSNumber numberWithDouble:self.longitude];
    wrapper.floor = self.floor;
    return wrapper;
}
    
    @end
