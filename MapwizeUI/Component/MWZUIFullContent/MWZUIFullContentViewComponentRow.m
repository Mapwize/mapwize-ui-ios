#import "MWZUIFullContentViewComponentRow.h"

@implementation MWZUIFullContentViewComponentRow

- (instancetype) initWithImage:(UIImage*)image contentView:(UIView*)contentView color:(UIColor*)color tapGestureRecognizer:(nullable UITapGestureRecognizer*)tapGestureRecognizer type:(MWZUIFullContentViewComponentRowType)type infoAvailable:(BOOL) infoAvailable {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _image = image;
        _contentView = contentView;
        _tapGestureRecognizer = tapGestureRecognizer;
        _type = type;
        _infoAvailable = infoAvailable;
        _color = color;
        [self setup];
    }
    return self;
}

- (void) setup {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    if (_infoAvailable) {
        [imageView setTintColor:_color];
    }
    else {
        [imageView setTintColor:[UIColor darkGrayColor]];
    }
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    [[_contentView.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:16] setActive:YES];
    [[_contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[_contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[_contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0] setActive:YES];
    NSLayoutConstraint* c = [_contentView.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor];
    c.priority = 800;
    [c setActive:YES];
    if (_tapGestureRecognizer) {
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
}

@end
