#ifndef MWZUIDirectionSceneDelegate_h
#define MWZUIDirectionSceneDelegate_h

@class MWZUIDirectionScene;
@class MWZUniverse;
@protocol MWZObject;

@protocol MWZUIDirectionSceneDelegate <NSObject>

- (void) directionSceneDidTapOnBackButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnFromButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnToButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnSwapButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneAccessibilityModeDidChange:(BOOL) isAccessible;
- (void) searchDirectionQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe forQuery:(NSString*) query;
- (void) directionSceneDidTapOnCurrentLocation:(MWZUIDirectionScene*) scene;

@end

#endif /* MWZDirectionSceneDelegate_h */
