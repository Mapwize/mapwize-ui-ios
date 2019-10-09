#ifndef MWZComponentSearchBarDelegate_h
#define MWZComponentSearchBarDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>
#import "MWZComponentRequireMapwizeInformationProtocol.h"

@protocol MWZComponentSearchBarDelegate <MWZComponentRequireMapwizeInformationProtocol>

- (void) didPressMenu;
- (void) didPressDirection;
- (void) didSelectVenue:(MWZVenue*) venue;
- (void) didSelectPlace:(MWZPlace*) place universe:(MWZUniverse*) universe;
- (void) didSelectPlaceList:(MWZPlacelist*) placelist universe:(MWZUniverse*) universe;
- (void) didStartLoading;
- (void) didStopLoading;

@end

#endif
