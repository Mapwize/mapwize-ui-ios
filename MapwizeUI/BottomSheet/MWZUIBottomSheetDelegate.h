#ifndef MWZUIBottomSheetDelegate_h
#define MWZUIBottomSheetDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>
@class MWZUIBottomSheet;
@class MWZUIBottomSheetComponents;

@protocol MWZUIBottomSheetDelegate <NSObject>

- (MWZUIBottomSheetComponents*) requireComponentForPlaceDetails:(MWZPlaceDetails*)placeDetails withDefaultComponents:(MWZUIBottomSheetComponents*)components;

- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components;

- (void) didClose;

- (void) didTapOnDirectionButton;

- (void) didTapOnCallButton;

- (void) didTapOnShareButton;

- (void) didTapOnWebsiteButton;

- (void) didTapOnInfoButton;

@end

#endif /* MWZUIBottomSheetDelegate_h */
