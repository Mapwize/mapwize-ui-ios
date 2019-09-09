#ifndef MWZMapwizeViewDelegate_h
#define MWZMapwizeViewDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>
@class MWZMapwizeView;
@class MWZFloor;

@protocol MWZMapwizeViewDelegate <NSObject>

- (void) mapwizeViewDidLoad:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceListInformationButton:(MWZPlacelist*) placeList;
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeViewDidTapOnMenu:(MWZMapwizeView*) mapwizeView;

@optional
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowFloorControllerFor:(NSArray<MWZFloor*>*) floors;
- (void) mapwizeUniverseHasChanged:(MWZUniverse*)universe;
@end

#endif
