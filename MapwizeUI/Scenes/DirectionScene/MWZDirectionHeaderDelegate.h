#ifndef MWZDirectionHeaderDelegate_h
#define MWZDirectionHeaderDelegate_h

@class MWZDirectionHeader;
@protocol MWZDirectionHeaderDelegate <NSObject>

- (void) directionHeaderDidTapOnBackButton:(MWZDirectionHeader*) directionHeader;

@end

#endif /* MWZDirectionHeaderDelegate_h */
