#import <UIKit/UIKit.h>
#import <MapwizeSDK/MapwizeSDK.h>

@class MWZSearchData;
@class MWZMapwizeViewUISettings;
@protocol MWZComponentSearchBarDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentSearchBar : UIView

@property (nonatomic, weak) id<MWZComponentSearchBarDelegate> delegate;

- (instancetype) initWith:(MWZSearchData*) searchData
               uiSettings:(MWZMapwizeViewUISettings*) uiSettings
               mapwizeApi:(id<MWZMapwizeApi>) mapwizeApi;

- (void) mapwizeWillEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue;
- (void) mapwizeDidExitVenue:(MWZVenue*) venue;

@end

NS_ASSUME_NONNULL_END
