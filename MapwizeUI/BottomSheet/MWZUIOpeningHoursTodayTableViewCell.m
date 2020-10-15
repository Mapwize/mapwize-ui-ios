//
//  MWZUIOpeningHoursTodayTableViewCell.m
//  MapwizeUI
//
//  Created by Etienne on 15/10/2020.
//  Copyright © 2020 Etienne Mercier. All rights reserved.
//

#import "MWZUIOpeningHoursTodayTableViewCell.h"

@implementation MWZUIOpeningHoursTodayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    _hoursLabel = [[UILabel alloc] init];
    _hoursLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_hoursLabel];
    [[_hoursLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_hoursLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[_hoursLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:4] setActive:YES];
    [[_hoursLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4] setActive:YES];
    
}

@end
