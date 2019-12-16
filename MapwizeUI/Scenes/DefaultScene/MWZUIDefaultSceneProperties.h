#import <Foundation/Foundation.h>

@class MWZVenue;
@protocol MWZObject;

@interface MWZUIDefaultSceneProperties : NSObject

@property (nonatomic) MWZVenue* venue;
@property (nonatomic) BOOL venueLoading;
@property (nonatomic) id<MWZObject> selectedContent;
@property (nonatomic) NSString* language;
@property (nonatomic, assign) BOOL infoButtonHidden;

+ (instancetype) scenePropertiesWithProperties:(MWZUIDefaultSceneProperties*) properties;

@end
