#import "MWZComponentLoadingBar.h"

const double progressBarWidth = 200.0;

@interface MWZComponentLoadingBar ()

@property (nonatomic) UIView* progressBarIndicator;
@property (nonatomic) UIColor* backgroundColor;
@property (nonatomic) UIColor* progressColor;
@property (nonatomic) NSLayoutConstraint* rightConstraint;
@property (nonatomic) NSLayoutConstraint* widthConstraint;

@end

@implementation MWZComponentLoadingBar

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        [self setHidden:YES];
        _progressBarIndicator = [[UIView alloc] init];
        _progressBarIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;
        _progressBarIndicator.layer.cornerRadius = 1.5f;
        self.layer.cornerRadius = 1.5f;
        [self addSubview:_progressBarIndicator];
        [[NSLayoutConstraint constraintWithItem:_progressBarIndicator
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:_progressBarIndicator
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        _rightConstraint = [NSLayoutConstraint constraintWithItem:_progressBarIndicator
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1.0f
                                                        constant:progressBarWidth];
        _widthConstraint = [NSLayoutConstraint constraintWithItem:_progressBarIndicator
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0f
                                                        constant:progressBarWidth];
        
        [_rightConstraint setActive:YES];
        [_widthConstraint setActive:YES];
        
        
        [self setBackgroundColor:[color colorWithAlphaComponent:0.3f]];
        [_progressBarIndicator setBackgroundColor:[color colorWithAlphaComponent:1.0f]];
        
    }
    return self;
}

- (void) startAnimation {
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _rightConstraint.constant = progressBarWidth / 4;
    [self setHidden:NO];

    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:1.0f animations:^{
        self.rightConstraint.constant = self.frame.size.width + progressBarWidth * 3 / 4;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.rightConstraint.constant = progressBarWidth / 4;
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (!self.isHidden) {
                [self startAnimation];
            }
        }];
        
    }];
}
    
- (void) stopAnimation {
    [self setHidden:YES];
}
    
@end
