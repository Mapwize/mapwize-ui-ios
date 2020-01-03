#ifndef MWZUICompassDelegate_h
#define MWZUICompassDelegate_h

@class MWZUICompass;

@protocol MWZUICompassDelegate <NSObject>

- (void) didPress:(MWZUICompass*) compass;

@end

#endif
