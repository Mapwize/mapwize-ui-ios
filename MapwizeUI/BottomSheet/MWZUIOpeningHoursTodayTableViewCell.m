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
    
    
    _toggleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _toggleImage.translatesAutoresizingMaskIntoConstraints = NO;
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UIImage* chevron = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    _toggleImage.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180);
    _toggleImage.image = chevron;
    [self addSubview:_toggleImage];
    [[_toggleImage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[_toggleImage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[_toggleImage.widthAnchor constraintEqualToConstant:24.0] setActive:YES];
    [[_toggleImage.heightAnchor constraintEqualToConstant:24.0] setActive:YES];
}

@end
