#import <IndoorLocation/IndoorLocation.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZIndoorLocation : ILIndoorLocation <MWZDirectionPoint>

- (instancetype) initWith:(ILIndoorLocation*) indoorLocation;
    
@end

NS_ASSUME_NONNULL_END
