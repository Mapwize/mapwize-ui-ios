#import "MWZUIDirectionModeSegment.h"

@implementation MWZUIDirectionModeSegment

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        _color = color;
        _buttons = [[NSMutableArray alloc] init];
        [self initialize];
    }
    return self;
}

- (void) initialize {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    [[self.scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0.0] setActive:YES];
    [[self.scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0.0] setActive:YES];
    [[self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0] setActive:YES];
    [[self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0] setActive:YES];
    
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.distribution = UIStackViewDistributionFill;
    [self.scrollView addSubview:self.stackView];
    
    [[self.stackView.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor constant:0.0] setActive:YES];
    [[self.stackView.rightAnchor constraintEqualToAnchor:self.stackView.rightAnchor constant:0.0] setActive:YES];
    [[self.stackView.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:0.0] setActive:YES];
    [[self.stackView.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:0.0] setActive:YES];
}

- (void) setModes:(NSArray<MWZDirectionMode *> *)modes {
    for (UIView* view in self.stackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    _modes = modes;
    int divider = modes.count > 4 ? 4 : (int)modes.count;
    int size = self.frame.size.width / divider;
    for (MWZDirectionMode* mode in _modes) {
        UIButton* button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[button.widthAnchor constraintEqualToConstant:size] setActive:YES];
        [button setImage:[mode.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat redComponent = CGColorGetComponents(self.color.CGColor)[0];
        CGFloat greenComponent = CGColorGetComponents(self.color.CGColor)[1];
        CGFloat blueComponent = CGColorGetComponents(self.color.CGColor)[2];
        self.haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
        button.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
        [button addTarget:self action:@selector(didTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self.stackView addArrangedSubview:button];
    }
    
    if (_selectedMode == nil || [_modes indexOfObject:_selectedMode] == NSNotFound) {
        [_delegate directionModeSegment:self didChangeMode:self.modes[0]];
    }
    
    if (self.selectorView != nil) {
        [self.selectorView removeFromSuperview];
    }
    self.selectorView = [[UIView alloc] init];
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectorView.layer.cornerRadius = 16.0;
    self.selectorView.layer.borderWidth = 0.3;
    self.selectorView.layer.masksToBounds = YES;
    self.selectorView.layer.backgroundColor = self.haloColor.CGColor;
    self.selectorView.layer.borderColor = self.color.CGColor;
    [self.stackView addSubview:self.selectorView];
    [[self.selectorView.heightAnchor constraintEqualToAnchor:self.buttons[0].heightAnchor multiplier:1.0] setActive:YES];
    [[self.selectorView.widthAnchor constraintEqualToAnchor:self.buttons[0].widthAnchor multiplier:1.0] setActive:YES];
    
    self.scrollView.contentSize = CGSizeMake(size*modes.count, self.scrollView.contentSize.height);
}

- (void) setSelectedMode:(MWZDirectionMode*) mode {
    UIButton* toButton = nil;
    for (int i=0; i<self.modes.count; i++) {
        if (mode == self.modes[i]) {
            [self.buttons[i] setTintColor:self.color];
            toButton = self.buttons[i];
        }
        else {
            [self.buttons[i] setTintColor:[UIColor blackColor]];
        }
    }
    if (mode == _selectedMode) {
        [UIView animateWithDuration:0.0 animations:^{
            [self.selectorView setTransform:CGAffineTransformMakeTranslation(toButton.frame.origin.x, 0.0)];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectorView setTransform:CGAffineTransformMakeTranslation(toButton.frame.origin.x, 0.0)];
        }];
    }
    
    _selectedMode = mode;
}

- (void) didTapOnButton:(UIButton*) sender {
    for (int i=0; i<self.modes.count; i++) {
        if (self.buttons[i] == sender) {
            [self setSelectedMode:self.modes[i]];
            [_delegate directionModeSegment:self didChangeMode:self.modes[i]];
            return;
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setSelectedMode:_selectedMode];
}

@end
