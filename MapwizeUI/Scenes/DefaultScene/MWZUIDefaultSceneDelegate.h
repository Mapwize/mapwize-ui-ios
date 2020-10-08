#ifndef MWZUIDefaultSceneDelegate_h
#define MWZUIDefaultSceneDelegate_h

@class MWZUIBottomSheetComponents;
@class MWZPlace;
@class MWZPlacelist;
@class MWZUIBottomSheetComponents;

@protocol MWZUIDefaultSceneDelegate <NSObject>

- (void) didTapOnSearchButton;
- (void) didTapOnMenuButton;
- (void) didTapOnDirectionButton;
- (void) didTapOnInformationButton;
- (MWZUIBottomSheetComponents*) requireComponentForPlace:(MWZPlace*)place withDefaultComponents:(MWZUIBottomSheetComponents*)components;
- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components;
@end

#endif /* MWZDefaultSceneDelegate_h */
