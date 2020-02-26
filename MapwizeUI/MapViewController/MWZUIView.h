#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>
@protocol MWZUIViewDelegate;
@protocol MWZUISearchSceneDelegate;
@protocol MWZUIDefaultSceneDelegate;
@protocol MWZUIDirectionSceneDelegate;
@protocol MWZUIFloorControllerDelegate;
@protocol MWZUICompassDelegate;
@protocol MWZUIFollowUserButtonDelegate;
@protocol MWZUILanguagesButtonDelegate;
@protocol MWZUIUniversesButtonDelegate;

@class MWZUISceneCoordinator;

@class MWZUISettings;
@class MWZUIOptions;
@class MWZUIFollowUserButton;
NS_ASSUME_NONNULL_BEGIN

/**
 MWZUIView contains a MWZMapView and some basic UI Components such as SearchBar, DirectionSearchEngine, FloorController and others.
 It is an easy way to integrate Mapwize without bothering building the entire UI
 */
@interface MWZUIView : UIView

/// The MWZMapView integrated in the MWZUIView
@property (nonatomic) MWZMapView* mapView;
/// The MWZUIViewDelegate that allows you to react to the map events
@property (nonatomic, weak) id<MWZUIViewDelegate> delegate;
/// The MWZUIFollowUserButton is exposed to help you align your UI to existing component
@property (nonatomic) MWZUIFollowUserButton* followUserButton;

/**
 Init the MWZUIView using the global MWZMapwizeConfiguration (see SDK documentation for more information)
 */
- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZUISettings*) uiSettings;

/**
Init the MWZUIView using the MWZMapwizeConfiguration passed as parameter (see SDK documentation for more information)
*/
- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZUISettings*) uiSettings;

/**
 Set the indoorLocationProvider to the map in order to display the user location returned by this provider
 */
- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

/**
 Helper methods to add access to the map using an access key
 */
- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

/**
 Select the place passed as parameter. Selecting a place add a marker on the place and open the bottom view to show information about it.
 */
- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;

/**
Select the placelist passed as parameter. Selecting a placelist add a marker on the places contained in the placelist and open the bottom view to show information about it.
*/
- (void) selectPlaceList:(MWZPlacelist*) placeList;

/**
 Unselect the selected place or placelist and hide related UI component
 */
- (void) unselectContent;

/**
 Display a direction on the map and change the UI to display the direction interface
 */
- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;


@end

NS_ASSUME_NONNULL_END
