#import "MWZDirectionModeSegment.h"

@implementation MWZDirectionModeSegment

- (instancetype) initWithItems:(NSArray<MWZDirectionMode*>*)modes color:(UIColor*) color {
    self = [super init];
    if (self) {
        _modes = modes;
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
    for (MWZDirectionMode* mode in self.modes) {
        UIButton* button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setImage:mode.image forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat redComponent = CGColorGetComponents(self.color.CGColor)[0];
        CGFloat greenComponent = CGColorGetComponents(self.color.CGColor)[1];
        CGFloat blueComponent = CGColorGetComponents(self.color.CGColor)[2];
        self.haloColor = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.1f];
        /*button.layer.cornerRadius = 16.0;
        button.layer.borderWidth = 0.3;
        button.layer.masksToBounds = YES;*/
        button.contentEdgeInsets = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
        [button addTarget:self action:@selector(didTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self addArrangedSubview:button];
    }
    [self setSelectedMode:self.modes[0]];
    
    self.selectorView = [[UIView alloc] init];
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectorView.backgroundColor = [UIColor redColor];
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
            /*self.buttons[i].backgroundColor = self.haloColor;
            self.buttons[i].layer.borderColor = self.color.CGColor;*/
            toButton = self.buttons[i];
        }
        else {
            [self.buttons[i] setTintColor:[UIColor blackColor]];
            /*self.buttons[i].backgroundColor = [UIColor colorWithRed:197.f/255.f green:21.f/255.f blue:134.f/255.f alpha:0.0f];
            self.buttons[i].layer.borderColor = [UIColor whiteColor].CGColor;*/
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.selectorView setTransform:CGAffineTransformMakeTranslation(toButton.frame.origin.x, 0.0)];
    }];
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
