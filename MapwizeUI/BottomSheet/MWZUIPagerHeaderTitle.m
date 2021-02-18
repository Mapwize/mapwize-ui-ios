//
//  MWZUIPagerHeaderButton.m
//  MapwizeUI
//
//  Created by Etienne on 09/10/2020.
//  Copyright © 2020 Etienne Mercier. All rights reserved.
//

#import "MWZUIPagerHeaderTitle.h"

@implementation MWZUIPagerHeaderTitle

-(instancetype) initWithIndex:(NSNumber*)index title:(NSString*)title {
    self = [super init];
    if (self) {
        _title = title;
        _index = index;
    }
    return self;
}

@end
