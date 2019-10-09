#ifndef MWZComponentDirectionBarDelegate_h
#define MWZComponentDirectionBarDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZComponentRequireMapwizeInformationProtocol.h"

@protocol MWZComponentDirectionBarDelegate <MWZComponentRequireMapwizeInformationProtocol>
    
- (void) didPressBack;
- (void) didUpdateDirectionInfo:(double) travelTime distance:(double) distance;
- (void) didStopDirection;
- (void) didStartLoading;
- (void) didStopLoading;
- (void) didFindDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;

/*- (MWZVenue*) directionBarRequiresCurrentVenue:(MWZComponentDirectionBar*) directionBar;
- (NSString*) directionBarRequiresCurrentLanguage:(MWZComponentDirectionBar*) directionBar;
- (MWZUniverse*) directionBarRequiresCurrentUniverse:(MWZComponentDirectionBar*) directionBar;
- (ILIndoorLocation*) directionBarRequiresUserLocation:(MWZComponentDirectionBar*) directionBar;*/

@end

#endif
