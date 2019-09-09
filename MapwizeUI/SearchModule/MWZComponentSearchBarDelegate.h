#ifndef MWZComponentSearchBarDelegate_h
#define MWZComponentSearchBarDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentSearchBarDelegate <NSObject>

- (void) didPressMenu;
- (void) didPressDirection;
- (void) didSelectVenue:(MWZVenue*) venue;
- (void) didSelectPlace:(MWZPlace*) place universe:(MWZUniverse*) universe;
- (void) didSelectPlaceList:(MWZPlacelist*) placelist universe:(MWZUniverse*) universe;
- (void) didStartLoading;
- (void) didStopLoading;

- (MWZVenue*) searchBarRequiresCurrentVenue:(MWZComponentSearchBar*) searchBar;
- (NSString*) searchBarRequiresCurrentLanguage:(MWZComponentSearchBar*) searchBar;
- (MWZUniverse*) searchBarRequiresCurrentUniverse:(MWZComponentSearchBar*) searchBar;

@end

#endif
