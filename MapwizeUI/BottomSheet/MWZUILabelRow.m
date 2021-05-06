#import "MWZUILabelRow.h"

@implementation MWZUILabelRow

- (instancetype) initWithImage:(UIImage*)image label:(NSString*)label color:(UIColor*)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _image = image;
        _color = color;
        [self setupWithLabel:label];
    }
    return self;
}

- (void) setupWithLabel:(NSString*)label {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [imageView setTintColor:_color];
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    UILabel* labelView = [[UILabel alloc] initWithFrame:CGRectZero];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    labelView.text = label;
    [self addSubview:labelView];
    [[labelView.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:16] setActive:YES];
    [[labelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[labelView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[labelView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0] setActive:YES];
    NSLayoutConstraint* c = [labelView.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor];
    c.priority = 800;
    [c setActive:YES];
}

@end
