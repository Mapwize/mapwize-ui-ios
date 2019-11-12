#ifndef MWZDirectionSceneDelegate_h
#define MWZDirectionSceneDelegate_h

@class MWZDirectionScene;

@protocol MWZDirectionSceneDelegate <NSObject>

- (void) directionSceneDidTapOnBackButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnFromButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnToButton:(MWZDirectionScene*) scene;

@end

#endif /* MWZDirectionSceneDelegate_h */
