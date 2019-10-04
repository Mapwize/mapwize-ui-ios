#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZComponentDirectionBarDelegate;
@class MWZSearchData;

@interface MWZComponentDirectionBar : UIView

@property (nonatomic, weak) id<MWZComponentDirectionBarDelegate> delegate;
    
- (instancetype) initWithMapwizeApi:(id<MWZMapwizeApi>) mapwizeApi
                         searchData:(MWZSearchData*) searchData
                              color:(UIColor*) color;
    
- (void) show;
- (void) hide;
- (void) setAccessibility:(BOOL) isAccessible;
- (void) setFrom:(id<MWZDirectionPoint>) fromValue;
- (void) setTo:(id<MWZDirectionPoint>) toValue;
- (void) didTapOnPlace:(MWZPlace*) place;

@end
