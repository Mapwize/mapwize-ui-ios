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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    [[_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[_titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    
}

@end
