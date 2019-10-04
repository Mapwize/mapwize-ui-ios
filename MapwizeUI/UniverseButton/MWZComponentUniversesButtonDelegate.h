#import <MapwizeSDK/MapwizeSDK.h>

#ifndef MWZComponentUniversesButtonDelegate_h
#define MWZComponentUniversesButtonDelegate_h

@protocol MWZComponentUniversesButtonDelegate <NSObject>

- (void) didSelectUniverse:(MWZUniverse*) universe;

@end

#endif
