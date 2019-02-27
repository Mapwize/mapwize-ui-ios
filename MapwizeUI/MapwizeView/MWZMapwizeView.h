#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>
@protocol MWZMapwizeViewDelegate;
@class MWZMapwizeViewUISettings;
@class MWZUIOptions;
NS_ASSUME_NONNULL_BEGIN

@interface MWZMapwizeView : UIView

@property (nonatomic, retain) MGLMapView* mapboxMap;
@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;
@property (nonatomic, weak) id<MWZMapwizeViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame mapwizeOptions:(MWZUIOptions*) options uiSettings:(MWZMapwizeViewUISettings*) uiSettings;
    
- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

@end

NS_ASSUME_NONNULL_END
