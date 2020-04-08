#ifndef MWZUIDirectionSceneDelegate_h
#define MWZUIDirectionSceneDelegate_h

@import MapwizeSDK;

@class MWZUIDirectionScene;

@protocol MWZUIDirectionSceneDelegate <NSObject>

- (void) directionSceneDidTapOnBackButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnFromButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnToButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDidTapOnSwapButton:(MWZUIDirectionScene*) scene;
- (void) directionSceneDirectionModeDidChange:(MWZDirectionMode*) directionMode;
- (void) searchDirectionQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe forQuery:(NSString*) query;
- (void) directionSceneDidTapOnCurrentLocation:(MWZUIDirectionScene*) scene;

@end

#endif /* MWZDirectionSceneDelegate_h */
