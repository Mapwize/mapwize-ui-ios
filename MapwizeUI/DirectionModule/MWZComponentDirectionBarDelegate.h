#ifndef MWZComponentDirectionBarDelegate_h
#define MWZComponentDirectionBarDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentDirectionBarDelegate <NSObject>
    
- (void) didPressBack;
- (void) didStartDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to;
- (void) didStopDirection;
    
@end

#endif
