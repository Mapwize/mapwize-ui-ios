#ifndef MWZComponentResultListDelegate_h
#define MWZComponentResultListDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentResultListDelegate <NSObject>

- (void) didSelect:(id<MWZObject>) mapwizeObject;

@end

#endif
