#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MWZUIOpeningInterval;

@interface MWZUIOpeningHoursUtils : NSObject

+ (NSArray<MWZUIOpeningInterval*>*) getSortedIntervals:(NSArray<NSDictionary*>*) input;
+ (NSString*) getCurrentOpeningStateString:(NSArray<NSDictionary*>*) input;
+ (NSString*) getDayName:(NSInteger)day;
+ (NSString*) getFormattedHours:(NSInteger)minuts;
+ (NSArray<NSDictionary*>*) getOpeningStrings:(NSArray<NSDictionary*>*) input;
@end

NS_ASSUME_NONNULL_END
