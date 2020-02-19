#ifndef MWZUIGroupedResultListDelegate_h
#define MWZUIGroupedResultListDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZUIGroupedResultListDelegate <NSObject>

- (void) didSelect:(id<MWZObject>) mapwizeObject universe:(MWZUniverse*) universe forQuery:(NSString*) query;

@end

#endif
