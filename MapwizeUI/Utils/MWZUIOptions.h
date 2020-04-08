#import <Foundation/Foundation.h>

@import MapwizeSDK;

/**
 This class allows to pass MWZOptions to the map with option that are not in the MapwizeSDK
 */
@interface MWZUIOptions : MWZOptions

/**
 The location to center on
 */
@property (nonatomic, retain) MWZLatLngFloor* _Nullable centerOnLocation;

@end
