#ifndef MWZUIFollowUserButtonDelegate_h
#define MWZUIFollowUserButtonDelegate_h

@class MWZUIFollowUserButton;

@protocol MWZUIFollowUserButtonDelegate <NSObject>
    
- (void) didTapWithoutLocation;
- (void) followUserButton:(MWZUIFollowUserButton*) followUserButton didChangeFollowUserMode:(MWZFollowUserMode) followUserMode;
- (ILIndoorLocation*) followUserButtonRequiresUserLocation:(MWZUIFollowUserButton*) followUserButton;
- (MWZFollowUserMode) followUserButtonRequiresFollowUserMode:(MWZUIFollowUserButton*) followUserButton;

@end

#endif
