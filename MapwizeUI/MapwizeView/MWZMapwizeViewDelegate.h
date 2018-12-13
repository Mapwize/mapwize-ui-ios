#ifndef MWZMapwizeViewDelegate_h
#define MWZMapwizeViewDelegate_h

#import <MapwizeForMapbox/MapwizeForMapbox.h>
@class MWZMapwizeView;

@protocol MWZMapwizeViewDelegate <NSObject>

- (void) mapwizeViewDidLoad:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceListInformationButton:(MWZPlaceList*) placeList;
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeViewDidTapOnMenu:(MWZMapwizeView*) mapwizeView;

- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowFloorControllerFor:(NSArray<NSNumber*>*) floors;


@end

#endif
