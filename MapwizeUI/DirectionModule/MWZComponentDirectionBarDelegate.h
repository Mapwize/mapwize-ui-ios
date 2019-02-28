#ifndef MWZComponentDirectionBarDelegate_h
#define MWZComponentDirectionBarDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentDirectionBarDelegate <NSObject>
    
- (void) didPressBack;
- (void) didUpdateDirectionInfo:(double) travelTime distance:(double) distance;
- (void) didStopDirection;
- (void) didStartLoading;
- (void) didStopLoading;
    
@end

#endif
