#ifndef MWZUIDirectionHeaderDelegate_h
#define MWZUIDirectionHeaderDelegate_h

@class MWZUIDirectionHeader;
@protocol MWZUIDirectionHeaderDelegate <NSObject>

- (void) directionHeaderDidTapOnBackButton:(MWZUIDirectionHeader*) directionHeader;
- (void) directionHeaderDidTapOnFromButton:(MWZUIDirectionHeader*) directionHeader;
- (void) directionHeaderDidTapOnToButton:(MWZUIDirectionHeader*) directionHeader;
- (void) directionHeaderDidTapOnSwapButton:(MWZUIDirectionHeader*) directionHeader;
- (void) directionHeaderAccessibilityModeDidChange:(BOOL) isAccessible;
- (void) searchDirectionQueryDidChange:(NSString*) query;

@end

#endif /* MWZUIDirectionHeaderDelegate_h */
