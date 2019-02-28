#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>
@protocol MWZMapwizeViewDelegate;
@class MWZMapwizeViewUISettings;
NS_ASSUME_NONNULL_BEGIN

@interface MWZMapwizeView : UIView

@property (nonatomic, retain) MGLMapView* mapboxMap;
@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;
@property (nonatomic, weak) id<MWZMapwizeViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame mapwizeOptions:(MWZOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings;
    
- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;

- (void) selectPlaceList:(MWZPlaceList*) placeList;

- (void) unselectContent:(BOOL) closeInfo;

- (void) setDirection:(MWZDirection*) direction from:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
