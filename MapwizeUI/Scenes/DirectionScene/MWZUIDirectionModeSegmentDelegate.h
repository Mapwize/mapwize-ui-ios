#ifndef MWZUIDirectionModeSegmentDelegate_h
#define MWZUIDirectionModeSegmentDelegate_h

@class MWZUIDirectionModeSegment;
@class MWZDirectionMode;

@protocol MWZUIDirectionModeSegmentDelegate <NSObject>

- (void) directionModeSegment:(MWZUIDirectionModeSegment*) segment didChangeMode:(MWZDirectionMode*) mode;

@end

#endif /* MWZDirectionModeSegmentDelegate_h */
