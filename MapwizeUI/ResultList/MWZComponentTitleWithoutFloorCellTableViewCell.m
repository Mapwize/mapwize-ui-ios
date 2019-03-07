#import "MWZComponentTitleWithoutFloorCellTableViewCell.h"

@implementation MWZComponentTitleWithoutFloorCellTableViewCell

@synthesize imageView;
@synthesize titleView;

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
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-16.0f] setActive:YES];
    
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
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
}

@end
