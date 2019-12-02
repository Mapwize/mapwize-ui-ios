#ifndef MWZDirectionModeSegmentDelegate_h
#define MWZDirectionModeSegmentDelegate_h

@class MWZDirectionModeSegment;
@class MWZDirectionMode;

@protocol MWZDirectionModeSegmentDelegate <NSObject>

- (void) directionModeSegment:(MWZDirectionModeSegment*) segment didChangeMode:(MWZDirectionMode*) mode;

@end

#endif /* MWZDirectionModeSegmentDelegate_h */
