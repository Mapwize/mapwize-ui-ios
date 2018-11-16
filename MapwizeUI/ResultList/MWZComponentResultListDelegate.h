#ifndef MWZComponentResultListDelegate_h
#define MWZComponentResultListDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentResultListDelegate <NSObject>

- (void) didSelect:(id<MWZObject>) mapwizeObject;

@end

#endif
