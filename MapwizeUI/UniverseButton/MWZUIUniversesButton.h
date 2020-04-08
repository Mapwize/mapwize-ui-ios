#import <UIKit/UIKit.h>

@import MapwizeSDK;

@protocol MWZUIUniversesButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIUniversesButton : UIButton

@property (nonatomic, weak) id<MWZUIUniversesButtonDelegate> delegate;

- (instancetype) init;

- (void) showIfNeeded;
- (void) mapwizeAccessibleUniversesDidChange:(NSArray<MWZUniverse*>*) accessibleUniverses;

@end

NS_ASSUME_NONNULL_END
