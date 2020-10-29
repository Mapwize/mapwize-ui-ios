#import "MWZUIIssueTypeCell.h"

@implementation MWZUIIssueTypeCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        [_label setFont:[UIFont systemFontOfSize:14]];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_label];
        [[_label.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor] setActive:YES];
        [[_label.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor constant:8] setActive:YES];
        [[_label.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor constant:-8] setActive:YES];
        [[_label.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor] setActive:YES];
        self.layer.cornerRadius = 16;
    }
    return self;
}

- (void) setColor:(UIColor *)color {
    _color = color;
    self.layer.borderColor = _color.CGColor;
    self.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = _color;
        _label.textColor = [UIColor whiteColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        _label.textColor = [UIColor blackColor];
        
    }
}

@end
