#ifndef MWZSearchSceneDelegate_h
#define MWZSearchSceneDelegate_h

@protocol MWZSearchSceneDelegate <NSObject>

- (void) didTapOnBackButton;
- (void) searchQueryDidChange:(NSString*) query;

@end

#endif /* MWZSearchSceneDelegate_h */
