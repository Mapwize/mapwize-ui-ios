#ifndef MWZComponentSearchBarDelegate_h
#define MWZComponentSearchBarDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentSearchBarDelegate <NSObject>

- (void) didPressMenu;
- (void) didPressDirection;
- (void) didSelectVenue:(MWZVenue*) venue;
- (void) didSelectPlace:(MWZPlace*) place universe:(MWZUniverse*) universe;
- (void) didSelectPlaceList:(MWZPlaceList*) placelist universe:(MWZUniverse*) universe;

@end

#endif
