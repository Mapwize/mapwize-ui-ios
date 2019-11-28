#import <Foundation/Foundation.h>

@class MWZVenue;
@protocol MWZObject;

@interface MWZDefaultSceneProperties : NSObject

@property (nonatomic) MWZVenue* venue;
@property (nonatomic) id<MWZObject> selectedContent;
@property (nonatomic) NSString* language;
@property (nonatomic, assign) BOOL infoButtonHidden;

+ (instancetype) scenePropertiesWithProperties:(MWZDefaultSceneProperties*) properties;

@end
