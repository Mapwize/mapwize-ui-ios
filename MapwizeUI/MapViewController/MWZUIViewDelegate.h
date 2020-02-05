#ifndef MWZUIViewDelegate_h
#define MWZUIViewDelegate_h

@class MWZUIView;
@protocol MWZUIViewDelegate <NSObject>

- (void) mapwizeViewDidLoad:(MWZUIView* _Nonnull) mapwizeView;

@optional

/**
 Called when the user click on the information button when a place is selected
 Can be use to open a new view to show more information about this place or redirect the user elsewhere in your application
 @param mapwizeView the view that triggered the event
 @param place the selected place when the click occurs
 */
- (void) mapwizeView:(MWZUIView* _Nonnull) mapwizeView didTapOnPlaceInformationButton:(MWZPlace* _Nonnull) place;

/**
 Called when the user click on the information button when a placelist is selected
 Can be use to open a new view to show more information about this placelist or redirect the user elsewhere in your application
 @param mapwizeView the view that triggered the event
 @param placelist the selected placelist when the click occurs
*/
- (void) mapwizeView:(MWZUIView* _Nonnull) mapwizeView didTapOnPlacelistInformationButton:(MWZPlacelist* _Nonnull) placelist;

/**
 Called when the user click on follow user mode button and no location is currently available
 Can be use to propose the user to activate the gps
 @param mapwizeView the view that triggered the event
*/
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZUIView* _Nonnull) mapwizeView;

/**
 Called when the user click on the menu button in the search bar
 Can be use to open a drawer menu
 @param mapwizeView the view that triggered the event
*/
- (void) mapwizeViewDidTapOnMenu:(MWZUIView* _Nonnull) mapwizeView;

/**
 Called when a place or a placelist is selected
 Information button can be useful if you have more information to display to the user or to redirect him elsewhere in your application
 @param mapwizeView the view that triggered the event
 @param mapwizeObject the selected object
 @return YES if the information button should be displayed. NO otherwise
*/
- (BOOL) mapwizeView:(MWZUIView* _Nonnull) mapwizeView shouldShowInformationButtonFor:(id<MWZObject> _Nonnull) mapwizeObject;

/**
 Called when the available floors change
 Floor controller is useful when you have multiple floor but you can decide to hide it if you have only one floor available.
 @param mapwizeView the view that triggered the event
 @param floors the new available floors
 @return YES if the floors controller should be displayed. NO otherwise
 */
- (BOOL) mapwizeView:(MWZUIView* _Nonnull) mapwizeView shouldShowFloorControllerFor:(NSArray<MWZFloor*>* _Nonnull) floors;

/**
 Called when the follow user mode changed.
 Can be used to change the UI depending on the current follow user mode
 @param mapwizeView the view that triggered the event
 @param followUserMode the active followUserMode
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView
followUserModeDidChange:(MWZFollowUserMode)followUserMode;

/**
 Called when the user click on the map
 @param mapwizeView the view that triggered the event
 @param clickEvent the click event produced by the click
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView didTap:(MWZClickEvent *_Nonnull)clickEvent;

/**
 Called when the MWZUIView starts to display a venue
 @param mapwizeView the view that triggered the event
 @param venue that will be displayed
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView venueWillEnter:(MWZVenue *_Nonnull)venue;

/**
 Called when the MWZUIView finishes to display a venue
 @param mapwizeView the view that triggered the event
 @param venue that is displayed
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView venueDidEnter:(MWZVenue *_Nonnull)venue;

/**
 Called when the MWZUIView hides a venue
 @param mapwizeView the view that triggered the event
 @param venue that is hidden
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView venueDidExit:(MWZVenue *_Nonnull)venue;

/**
 Called when the universe will change
 @param mapwizeView the view that triggered the event
 @param universe that will be displayed
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView universeWillChange:(MWZUniverse *_Nonnull)universe;

/**
 Called when the universe did change
 @param mapwizeView the view that triggered the event
 @param universe that is displayed
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView universeDidChange:(MWZUniverse *_Nonnull)universe;

/**
 Called when the universes available for the displayed venue changed. Triggered just after venueEnter or if new access are granted.
 @param mapwizeView the view that triggered the event
 @param universes the available universes
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView
universesDidChange:(NSArray<MWZUniverse *> *_Nonnull)universes;

/**
 Called when the MWZUIView will change the displayed floor
 @param mapwizeView the view that triggered the event
 @param floor that will be displayed
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView floorWillChange:(MWZFloor *_Nullable)floor;

/**
 Called when the MWZUIView changes the displayed floor
 @param mapwizeView the view that triggered the event
 @param floor the displayed floor
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView floorDidChange:(MWZFloor *_Nullable)floor;

/**
 Called when the MWZUIView changes the available floors for the displayed venue.
 Triggered just after venueDidEnter, universeDidChange and venueDidExit.
 Can also be triggered based on the map movements.
 @param mapwizeView the mapwize view that triggered the event
 @param floors the available floors
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView
floorsDidChange:(NSArray<MWZFloor *> *_Nonnull)floors;

/**
 Called when the MWZUIView needs to display the user location. Use this method to display a custom
 user location view. Specifications about the MGLUserLocationAnnotationView can be found at https://docs.mapbox.com/ios/api/maps
 */
- (MWZUserLocationAnnotationView *_Nonnull)viewForUserLocationAnnotation;

/**
 Called when a marker is tapped
 @param mapwizeView the view that triggered the event
 @param marker tapped
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView
 didTapOnMarker:(MWZMapwizeAnnotation *_Nonnull)marker;

/**
 Called when a navigation will start or will be recomputed
 */
- (void)mapwizeViewWillStartNavigation:(MWZUIView *_Nonnull)mapwizeView;

/**
 Called when a navigation is started or has been recompute
 */
- (void)mapwizeViewDidStartNavigation:(MWZUIView *_Nonnull)mapwizeView
                     forDirection:(MWZDirection* _Nonnull) direction;

/**
 Called when the navigation stopped
 */
- (void)mapwizeViewDidStopNavigation:(MWZUIView *_Nonnull)mapwizeView;

/**
 Called when the no direction have been found
 */
- (void)mapwizeView:(MWZUIView *_Nonnull)mapwizeView navigationFailedWithError:(NSError* _Nonnull) error;

/**
 Called during a navigation when the user location change.
 You should decide to recompute based on the navigation information (For exemple : return locationDelta > 10)
 */
- (BOOL)mapwizeView:(MWZUIView *_Nonnull) mapwizeView
shouldRecomputeNavigation:(MWZNavigationInfo* _Nonnull) navigationInfo;
@end

#endif
