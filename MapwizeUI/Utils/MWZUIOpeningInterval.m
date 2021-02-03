//
//  MWZUIOpeningInterval.m
//  MapwizeUI
//
//  Created by Etienne on 15/10/2020.
//  Copyright © 2020 Etienne Mercier. All rights reserved.
//

#import "MWZUIOpeningInterval.h"

@implementation MWZUIOpeningInterval

- (instancetype) initWithDay:(NSInteger)day open:(NSInteger)open close:(NSInteger)close {
    if (self = [super init]) {
        _day = day + 1;
        _open = open;
        _close = close;
    }
    return self;
}

@end
