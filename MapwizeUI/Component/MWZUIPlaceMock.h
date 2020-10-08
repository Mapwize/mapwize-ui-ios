//
//  MWZUIPlaceMock.h
//  BottomSheet
//
//  Created by Etienne on 28/09/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIPlaceMock : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) NSString* details;
@property (nonatomic) NSString* floorName;
@property (nonatomic) NSArray<NSString*>* imageUrls;
@property (nonatomic) NSString* iconUrl;
@property (nonatomic) NSString* phoneNumber;
@property (nonatomic) NSString* email;
@property (nonatomic) NSString* website;
@property (nonatomic) NSArray<NSDictionary*>* calendarEvents;
@property (nonatomic) NSArray<NSDictionary*>* openingHours;
@property (nonatomic, assign) BOOL sharable;

+ (instancetype) getMock1;
+ (instancetype) getMock2;

@end

NS_ASSUME_NONNULL_END
