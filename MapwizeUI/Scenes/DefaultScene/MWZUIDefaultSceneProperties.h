#import <Foundation/Foundation.h>

@import MapwizeSDK;

@interface MWZUIDefaultSceneProperties : NSObject

@property (nonatomic) MWZVenue* venue;
@property (nonatomic) BOOL venueLoading;
@property (nonatomic) id selectedContent;
@property (nonatomic) MWZPlaceDetails* placeDetails;
@property (nonatomic) NSString* language;
@property (nonatomic, assign) BOOL infoButtonHidden;

+ (instancetype) scenePropertiesWithProperties:(MWZUIDefaultSceneProperties*) properties;

@end
