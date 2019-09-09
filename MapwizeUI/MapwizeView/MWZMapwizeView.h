#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>
@protocol MWZMapwizeViewDelegate;
@class MWZMapwizeViewUISettings;
@class MWZUIOptions;
NS_ASSUME_NONNULL_BEGIN

@interface MWZMapwizeView : UIView

@property (nonatomic) MWZMapView* mapView;
@property (nonatomic, weak) id<MWZMapwizeViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;

- (void) selectPlaceList:(MWZPlacelist*) placeList;

- (void) unselectContent:(BOOL) closeInfo;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
