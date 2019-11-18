#ifndef MWZDirectionSceneDelegate_h
#define MWZDirectionSceneDelegate_h

@class MWZDirectionScene;
@protocol MWZObject;

@protocol MWZDirectionSceneDelegate <NSObject>

- (void) directionSceneDidTapOnBackButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnFromButton:(MWZDirectionScene*) scene;
- (void) directionSceneDidTapOnToButton:(MWZDirectionScene*) scene;
- (void) directionSceneAccessibilityModeDidChange:(BOOL) isAccessible;
- (void) searchDirectionQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject;

@end

#endif /* MWZDirectionSceneDelegate_h */
