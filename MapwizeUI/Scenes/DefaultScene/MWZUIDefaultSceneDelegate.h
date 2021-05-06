#ifndef MWZUIDefaultSceneDelegate_h
#define MWZUIDefaultSceneDelegate_h

@class MWZUIBottomSheetComponents;
@class MWZPlaceDetails;
@class MWZPlacelist;
@class MWZUIBottomSheetComponents;

@protocol MWZUIDefaultSceneDelegate <NSObject>

- (void) didTapOnSearchButton;
- (void) didTapOnMenuButton;
- (void) didTapOnInformationButton;
- (MWZUIBottomSheetComponents*) requireComponentForPlaceDetails:(MWZPlaceDetails*)placeDetails withDefaultComponents:(MWZUIBottomSheetComponents*)components;
- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components;
- (void) didClose;
- (void) didTapOnDirectionButton;
- (void) didTapOnCallButton;
- (void) didTapOnShareButton;
- (void) didTapOnWebsiteButton;
- (void) didTapOnReportIssueButton:(MWZPlaceDetails *)details;

@end

#endif /* MWZDefaultSceneDelegate_h */
