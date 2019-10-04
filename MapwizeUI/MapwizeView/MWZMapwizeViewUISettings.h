#import <MapwizeSDK/MapwizeSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZMapwizeViewUISettings: NSObject

@property (nonatomic, retain) UIColor* mainColor;
@property (nonatomic, assign) BOOL menuButtonIsHidden;
@property (nonatomic, assign) BOOL followUserButtonIsHidden;
@property (nonatomic, assign) BOOL floorControllerIsHidden;
@property (nonatomic, assign) BOOL compassIsHidden;

@end

NS_ASSUME_NONNULL_END
