#import "MWZUIPagerHeaderView.h"
#import "MWZUIPagerHeaderTitle.h"

@implementation MWZUIPagerHeaderView


- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        _color = color;
        _buttons = [[NSMutableArray alloc] init];
        _titles = @[];
        [self initialize];
    }
    return self;
}

- (void) initialize {
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:self.stackView];
    [[self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
}

- (void) setTitles:(NSArray<MWZUIPagerHeaderTitle *> *)titles {
    for (UIView* view in self.stackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    if (titles.count > 0) {
        _selectedTitle = titles[0];
    }
    _titles = titles;
    int divider = titles.count > 4 ? 4 : (int)titles.count;
    int size = self.frame.size.width / divider;
    for (MWZUIPagerHeaderTitle* title in _titles) {
        UIButton* button = [[UIButton alloc] init];
        
        [button setTitle:title.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat redComponent = CGColorGetComponents(self.color.CGColor)[0];
        CGFloat greenComponent = CGColorGetComponents(self.color.CGColor)[1];
        CGFloat blueComponent = CGColorGetComponents(self.color.CGColor)[2];
        self.haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
        //button.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
        [button addTarget:self action:@selector(didTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self.stackView addArrangedSubview:button];
        
    }
    
    if (self.selectorView != nil) {
        [self.selectorView removeFromSuperview];
    }
    if ([_titles count] == 0) {
        return;
    }
    self.selectorView = [[UIView alloc] init];
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectorView.layer.backgroundColor = self.color.CGColor;
    [self.stackView addSubview:self.selectorView];
    [[self.selectorView.heightAnchor constraintEqualToConstant:4] setActive:YES];
    [[self.selectorView.widthAnchor constraintEqualToAnchor:self.buttons[0].widthAnchor multiplier:1.0] setActive:YES];
    [[self.selectorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    
    if (_selectedTitle == nil) {
        [_delegate pagerHeader:self didChangeTitle:_selectedTitle];
    }
    else {
        [self setSelectedTitle:_selectedTitle];
    }
}

- (void) setSelectedIndex:(NSNumber*) index {
    [self setSelectedTitle:_titles[index.intValue]];
}

- (void) setSelectedTitle:(MWZUIPagerHeaderTitle*) title {
    UIButton* toButton = nil;
    for (int i=0; i<self.titles.count; i++) {
        if ([title isEqual:self.titles[i]]) {
            [self.buttons[i] setTitleColor:self.color forState:UIControlStateNormal];
            toButton = self.buttons[i];
        }
        else {
            [self.buttons[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    if ([title isEqual:_selectedTitle]) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.0 animations:^{
            [self.selectorView setTransform:CGAffineTransformMakeTranslation(toButton.frame.origin.x, 0.0)];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectorView setTransform:CGAffineTransformMakeTranslation(toButton.frame.origin.x, 0.0)];
        }];
    }
    
    _selectedTitle = title;
}

- (void) didTapOnButton:(UIButton*) sender {
    for (int i=0; i<self.titles.count; i++) {
        if (self.buttons[i] == sender) {
            [self setSelectedTitle:_titles[i]];
            [_delegate pagerHeader:self didChangeTitle:_titles[i]];
            return;
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setSelectedTitle:_selectedTitle];
}

@end
