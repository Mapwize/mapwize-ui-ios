#ifndef MWZUIDirectionModeSegmentDelegate_h
#define MWZUIDirectionModeSegmentDelegate_h

@import MapwizeSDK;

@class MWZUIDirectionModeSegment;

@protocol MWZUIDirectionModeSegmentDelegate <NSObject>

- (void) directionModeSegment:(MWZUIDirectionModeSegment*) segment didChangeMode:(MWZDirectionMode*) mode;

@end

#endif /* MWZDirectionModeSegmentDelegate_h */
