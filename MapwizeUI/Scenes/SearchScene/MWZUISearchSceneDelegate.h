#ifndef MWZUISearchSceneDelegate_h
#define MWZUISearchSceneDelegate_h

@protocol MWZUISearchSceneDelegate <NSObject>

- (void) didTapOnBackButton;
- (void) searchQueryDidChange:(NSString*) query;
- (void) didSelect:(id<MWZObject>)mapwizeObject universe:(MWZUniverse*) universe;

@end

#endif /* MWZSearchSceneDelegate_h */
