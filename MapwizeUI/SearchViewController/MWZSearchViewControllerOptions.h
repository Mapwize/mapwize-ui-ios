#import <Foundation/Foundation.h>
#import <MapwizeSDK/MapwizeSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZSearchViewControllerOptions : NSObject

@property (assign) BOOL isDirection;
@property (assign) BOOL isFrom;
@property (assign) BOOL isTo;
@property (nonatomic, copy) NSString* language;
@property (nonatomic, copy) NSString* venueId;
@property (nonatomic, copy) NSString* universeId;
@property (nonatomic, copy) NSArray<MWZUniverse*>* groupByUniverses;
@property (nonatomic, copy) ILIndoorLocation* indoorLocation;
@property (nonatomic, copy) MWZApiFilter* apiFilter;

@end

NS_ASSUME_NONNULL_END
