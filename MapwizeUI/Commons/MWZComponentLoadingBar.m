#import "MWZComponentLoadingBar.h"

const double progressBarWidth = 200.0;

@implementation MWZComponentLoadingBar {
    UIView* progressBarIndicator;
    UIColor* backgroundColor;
    UIColor* progressColor;
    
    NSLayoutConstraint* rightConstraint;
    NSLayoutConstraint* widthConstraint;
}

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        [self setHidden:YES];
        progressBarIndicator = [[UIView alloc] init];
        progressBarIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;
        progressBarIndicator.layer.cornerRadius = 1.5f;
        self.layer.cornerRadius = 1.5f;
        [self addSubview:progressBarIndicator];
        [[NSLayoutConstraint constraintWithItem:progressBarIndicator
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:progressBarIndicator
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        rightConstraint = [NSLayoutConstraint constraintWithItem:progressBarIndicator
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1.0f
                                                        constant:progressBarWidth];
        widthConstraint = [NSLayoutConstraint constraintWithItem:progressBarIndicator
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0f
                                                        constant:progressBarWidth];
        
        [rightConstraint setActive:YES];
        [widthConstraint setActive:YES];
        
        
        [self setBackgroundColor:[color colorWithAlphaComponent:0.3f]];
        [progressBarIndicator setBackgroundColor:[color colorWithAlphaComponent:1.0f]];
        
    }
    return self;
}

- (void) startAnimation {
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    rightConstraint.constant = progressBarWidth / 4;
    [self setHidden:NO];

    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:1.0f animations:^{
        self->rightConstraint.constant = self.frame.size.width + progressBarWidth * 3 / 4;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self->rightConstraint.constant = progressBarWidth / 4;
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
