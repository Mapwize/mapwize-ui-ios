#import "MWZDefaultSceneProperties.h"

@implementation MWZDefaultSceneProperties

+ (instancetype) scenePropertiesWithProperties:(MWZDefaultSceneProperties*) properties {
    MWZDefaultSceneProperties* p = [[MWZDefaultSceneProperties alloc] init];
    p.infoButtonHidden = properties.infoButtonHidden;
    p.language = properties.language;
    p.selectedContent = properties.selectedContent;
    p.venue = properties.venue;
    p.venueLoading = properties.venueLoading;
    return p;
}

@end
