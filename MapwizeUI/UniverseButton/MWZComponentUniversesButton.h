#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentUniversesButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentUniversesButton : UIButton

@property (nonatomic, weak) id<MWZComponentUniversesButtonDelegate> delegate;

- (instancetype) init;

- (void) showIfNeeded;
- (void) mapwizeAccessibleUniversesDidChange:(NSArray<MWZUniverse*>*) accessibleUniverses;

@end

NS_ASSUME_NONNULL_END
