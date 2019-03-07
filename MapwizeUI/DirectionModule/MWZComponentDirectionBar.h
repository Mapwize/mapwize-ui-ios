#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@protocol MWZComponentDirectionBarDelegate;
@class MWZSearchData;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentDirectionBar : UIView

@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;
@property (nonatomic, weak) id<MWZComponentDirectionBarDelegate> delegate;
    
- (instancetype) initWith:(MWZSearchData*) searchData color:(UIColor*) color;
    
- (void) show;
- (void) hide;
- (void) setAccessibility:(BOOL) isAccessible;
- (void) setFrom:(id<MWZDirectionPoint>) fromValue;
- (void) setTo:(id<MWZDirectionPoint>) toValue;
    
@end

NS_ASSUME_NONNULL_END
