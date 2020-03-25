#import "MWZUIDirectionModeSegment.h"

@implementation MWZUIDirectionModeSegment

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        _color = color;
        _buttons = [[NSMutableArray alloc] init];
        [self initialize];
        self.backgroundColor = [UIColor greenColor];
        self.axis = UILayoutConstraintAxisHorizontal;
        self.alignment = UIStackViewAlignmentFill;
        self.distribution = UIStackViewDistributionFillEqually;
    }
    return self;
}

- (void) initialize {
    
}

- (void) setModes:(NSArray<MWZDirectionMode *> *)modes {
    for (UIView* view in self.arrangedSubviews) {
        [view removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    _modes = modes;
    for (MWZDirectionMode* mode in _modes) {
        UIButton* button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setImage:[mode.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat redComponent = CGColorGetComponents(self.color.CGColor)[0];
        CGFloat greenComponent = CGColorGetComponents(self.color.CGColor)[1];
        CGFloat blueComponent = CGColorGetComponents(self.color.CGColor)[2];
        self.haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
        button.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
        [button addTarget:self action:@selector(didTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self addArrangedSubview:button];
    }
    
    if (_selectedMode == nil) {
        //[self setSelectedMode:self.modes[0]];
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
    [self addSubview:self.selectorView];
    [[self.selectorView.heightAnchor constraintEqualToAnchor:self.buttons[0].heightAnchor multiplier:1.0] setActive:YES];
    [[self.selectorView.widthAnchor constraintEqualToAnchor:self.buttons[0].widthAnchor multiplier:1.0] setActive:YES];
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
