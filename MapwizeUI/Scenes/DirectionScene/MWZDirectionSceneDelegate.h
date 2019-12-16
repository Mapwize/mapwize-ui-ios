#ifndef MWZDirectionSceneDelegate_h
#define MWZDirectionSceneDelegate_h

@class MWZDirectionScene;
@class MWZUniverse;
@protocol MWZObject;

@protocol MWZDirectionSceneDelegate <NSObject>

- (void) directionSceneDidTapOnBackButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnFromButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnToButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnSwapButton:(MWZDirectionScene*) scene;
- (void) directionSceneAccessibilityModeDidChange:(BOOL) isAccessible;
- (void) searchDirectionQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe;
- (void) directionSceneDidTapOnCurrentLocation:(MWZDirectionScene*) scene;

@end

#endif /* MWZDirectionSceneDelegate_h */
