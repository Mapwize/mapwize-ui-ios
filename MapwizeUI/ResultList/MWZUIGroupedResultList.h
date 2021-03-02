#import <UIKit/UIKit.h>

@import MapwizeSDK;

@protocol MWZUIGroupedResultListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIGroupedResultList : UIView

@property (nonatomic, weak) id<MWZUIGroupedResultListDelegate> resultDelegate;

- (void) setLanguage:(NSString*) language;
- (void) swapResults:(NSArray<id<MWZObject>>*) results
           universes:(NSArray<MWZUniverse*>*) universes
      activeUniverse:(MWZUniverse*) activeUniverse
            language:(NSString*) language
            forQuery:(NSString*) query;
- (void) swapResults:(NSArray<id<MWZObject>> *)results language:(NSString *)language forQuery:(NSString*) query;
- (void) setNetworkError:(BOOL)networkError;
@end

NS_ASSUME_NONNULL_END
