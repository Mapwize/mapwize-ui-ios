//
//  MWZUIOpeningHoursTableViewCell.m
//  BottomSheet
//
//  Created by Etienne on 02/10/2020.
//

#import "MWZUIOpeningHoursTableViewCell.h"

@implementation MWZUIOpeningHoursTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dayLabel];
    [[_dayLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_dayLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:4] setActive:YES];
    [[_dayLabel.widthAnchor constraintEqualToConstant:100] setActive:YES];
    
    _hoursLabel = [[UILabel alloc] init];
    _hoursLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_hoursLabel];
    [[_hoursLabel.leadingAnchor constraintEqualToAnchor:_dayLabel.trailingAnchor] setActive:YES];
    [[_hoursLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[_hoursLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:4] setActive:YES];
    [[_hoursLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4] setActive:YES];
    
    _toggleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _toggleImage.translatesAutoresizingMaskIntoConstraints = NO;
    _toggleImage.backgroundColor = [UIColor redColor];
    [self addSubview:_toggleImage];
    [[_toggleImage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[_toggleImage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[_toggleImage.widthAnchor constraintEqualToConstant:24.0] setActive:YES];
    [[_toggleImage.heightAnchor constraintEqualToConstant:24.0] setActive:YES];
    
}

@end
