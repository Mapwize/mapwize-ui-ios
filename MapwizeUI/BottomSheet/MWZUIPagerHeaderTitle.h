//
//  MWZUIPagerHeaderButton.h
//  MapwizeUI
//
//  Created by Etienne on 09/10/2020.
//  Copyright © 2020 Etienne Mercier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIPagerHeaderTitle : NSObject

@property (nonatomic) NSNumber* index;
@property (nonatomic) NSString* title;

-(instancetype) initWithIndex:(NSNumber*)index title:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
