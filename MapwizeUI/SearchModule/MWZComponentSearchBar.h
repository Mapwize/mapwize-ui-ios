#import <UIKit/UIKit.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@class MWZSearchData;
@class MWZMapwizeViewUISettings;
@protocol MWZComponentSearchBarDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentSearchBar : UIView

@property (nonatomic, weak) id<MWZComponentSearchBarDelegate> delegate;
@property (nonatomic, retain) MapwizePlugin* mapwizePlugin;

- (instancetype) initWith:(MWZSearchData*) searchData uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (void) mapwizeWillEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidExitVenue:(MWZVenue*) venue;

@end

NS_ASSUME_NONNULL_END
