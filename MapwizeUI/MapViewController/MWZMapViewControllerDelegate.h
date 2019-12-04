#ifndef MWZMapViewControllerDelegate_h
#define MWZMapViewControllerDelegate_h

@class MWZMapViewController;
@protocol MWZMapViewControllerDelegate <NSObject>

- (void) mapwizeViewDidLoad:(MWZMapViewController*) mapwizeView;
- (void) mapwizeView:(MWZMapViewController*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZMapViewController*) mapwizeView didTapOnPlacelistInformationButton:(MWZPlacelist*) placeList;
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZMapViewController*) mapwizeView;
- (void) mapwizeViewDidTapOnMenu:(MWZMapViewController*) mapwizeView;

@optional
- (BOOL) mapwizeView:(MWZMapViewController*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
- (BOOL) mapwizeView:(MWZMapViewController*) mapwizeView shouldShowFloorControllerFor:(NSArray<MWZFloor*>*) floors;
- (void) mapwizeUniverseHasChanged:(MWZUniverse*)universe __attribute__((deprecated("Use MWZMapViewDelegate instead")));
@end

#endif
