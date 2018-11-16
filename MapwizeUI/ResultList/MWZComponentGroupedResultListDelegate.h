#ifndef MWZComponentGroupedResultListDelegate_h
#define MWZComponentGroupedResultListDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentGroupedResultListDelegate <NSObject>

- (void) didSelect:(id<MWZObject>) mapwizeObject universe:(MWZUniverse*) universe;

@end

#endif
