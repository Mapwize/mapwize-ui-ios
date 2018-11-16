#ifndef MWZComponentCompassDelegate_h
#define MWZComponentCompassDelegate_h

@class MWZComponentCompass;

@protocol MWZComponentCompassDelegate <NSObject>

- (void) didPress:(MWZComponentCompass*) compass;

@end

#endif
