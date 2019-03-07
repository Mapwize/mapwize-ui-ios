#import "MWZComponentSubtitleCell.h"

@implementation MWZComponentSubtitleCell

@synthesize imageView;
@synthesize titleView;
@synthesize subtitleView;
@synthesize floorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setTintColor:[UIColor lightGrayColor]];
    [self addSubview:imageView];
    [[NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:24.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    titleView = [[UILabel alloc] init];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleView];
    [[NSLayoutConstraint constraintWithItem:titleView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:imageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:titleView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:titleView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:titleView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:21.0f] setActive:YES];
    
    subtitleView = [[UILabel alloc] init];
    subtitleView.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleView.textColor = [UIColor lightGrayColor];
    subtitleView.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:subtitleView];
    [[NSLayoutConstraint constraintWithItem:subtitleView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:titleView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:subtitleView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:subtitleView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:titleView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:subtitleView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:21.0f] setActive:YES];
    
    floorView = [[UILabel alloc] init];
    floorView.translatesAutoresizingMaskIntoConstraints = NO;
    floorView.textColor = [UIColor lightGrayColor];
    floorView.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:floorView];
    [[NSLayoutConstraint constraintWithItem:floorView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:imageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:floorView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:floorView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:floorView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:subtitleView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

@end
