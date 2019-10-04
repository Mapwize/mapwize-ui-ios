#import <Foundation/Foundation.h>
#import <MapwizeSDK/MapwizeSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchData : NSObject

@property (nonatomic, retain) NSMutableArray<MWZVenue*>* venues;
@property (nonatomic, retain) NSMutableArray<id<MWZObject>>* mainSearch;
@property (nonatomic, retain) NSMutableArray<MWZPlace*>* mainFrom;
@property (nonatomic, retain) NSMutableArray<MWZUniverse*>* accessibleUniverses;

@end

NS_ASSUME_NONNULL_END
