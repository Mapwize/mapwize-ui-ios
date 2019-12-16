#ifndef MWZUIViewDelegate_h
#define MWZUIViewDelegate_h

@class MWZUIView;
@protocol MWZUIViewDelegate <NSObject>

- (void) mapwizeViewDidLoad:(MWZUIView*) mapwizeView;
- (void) mapwizeView:(MWZUIView*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZUIView*) mapwizeView didTapOnPlacelistInformationButton:(MWZPlacelist*) placeList;
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZUIView*) mapwizeView;
- (void) mapwizeViewDidTapOnMenu:(MWZUIView*) mapwizeView;

@optional
- (BOOL) mapwizeView:(MWZUIView*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
- (BOOL) mapwizeView:(MWZUIView*) mapwizeView shouldShowFloorControllerFor:(NSArray<MWZFloor*>*) floors;
@end

#endif
