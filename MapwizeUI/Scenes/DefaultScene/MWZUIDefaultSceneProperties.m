#import "MWZUIDefaultSceneProperties.h"

@implementation MWZUIDefaultSceneProperties

+ (instancetype) scenePropertiesWithProperties:(MWZUIDefaultSceneProperties*) properties {
    MWZUIDefaultSceneProperties* p = [[MWZUIDefaultSceneProperties alloc] init];
    p.infoButtonHidden = properties.infoButtonHidden;
    p.language = properties.language;
    p.selectedContent = properties.selectedContent;
    p.venue = properties.venue;
    p.venueLoading = properties.venueLoading;
    p.placeDetails = properties.placeDetails;
    p.reportRowHidden = properties.reportRowHidden;
    return p;
}

@end
