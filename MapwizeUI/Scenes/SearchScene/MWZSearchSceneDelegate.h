#ifndef MWZSearchSceneDelegate_h
#define MWZSearchSceneDelegate_h

@protocol MWZSearchSceneDelegate <NSObject>

- (void) didTapOnBackButton;
- (void) searchQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe;

@end

#endif /* MWZSearchSceneDelegate_h */
