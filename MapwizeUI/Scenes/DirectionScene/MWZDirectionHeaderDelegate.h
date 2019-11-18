#ifndef MWZDirectionHeaderDelegate_h
#define MWZDirectionHeaderDelegate_h

@class MWZDirectionHeader;
@protocol MWZDirectionHeaderDelegate <NSObject>

- (void) directionHeaderDidTapOnBackButton:(MWZDirectionHeader*) directionHeader;
- (void) directionHeaderDidTapOnFromButton:(MWZDirectionHeader*) directionHeader;
- (void) directionHeaderDidTapOnToButton:(MWZDirectionHeader*) directionHeader;
- (void) directionHeaderAccessibilityModeDidChange:(BOOL) isAccessible;
- (void) searchDirectionQueryDidChange:(NSString*) query;

@end

#endif /* MWZDirectionHeaderDelegate_h */
