//
//  MWZUIOpeningInterval.h
//  MapwizeUI
//
//  Created by Etienne on 15/10/2020.
//  Copyright © 2020 Etienne Mercier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIOpeningInterval : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger open;
@property (nonatomic, assign) NSInteger close;

- (instancetype) initWithDay:(NSInteger)day open:(NSInteger)open close:(NSInteger)close;

@end

NS_ASSUME_NONNULL_END
