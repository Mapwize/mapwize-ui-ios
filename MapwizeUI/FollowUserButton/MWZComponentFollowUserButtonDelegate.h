#ifndef MWZComponentFollowUserButtonDelegate_h
#define MWZComponentFollowUserButtonDelegate_h

@protocol MWZComponentFollowUserButtonDelegate <NSObject>
    
- (void) didTapWithoutLocation;
- (void) followUserButton:(MWZComponentFollowUserButton*) followUserButton didChangeFollowUserMode:(MWZFollowUserMode) followUserMode;
- (ILIndoorLocation*) followUserButtonRequiresUserLocation:(MWZComponentFollowUserButton*) followUserButton;
- (MWZFollowUserMode) followUserButtonRequiresFollowUserMode:(MWZComponentFollowUserButton*) followUserButton;

@end

#endif
