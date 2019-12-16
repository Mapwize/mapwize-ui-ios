#ifndef MWZUIDirectionModeSegmentDelegate_h
#define MWZUIDirectionModeSegmentDelegate_h

@class MWZUIDirectionModeSegment;
@class MWZUIDirectionMode;

@protocol MWZUIDirectionModeSegmentDelegate <NSObject>

- (void) directionModeSegment:(MWZUIDirectionModeSegment*) segment didChangeMode:(MWZUIDirectionMode*) mode;

@end

#endif /* MWZDirectionModeSegmentDelegate_h */
