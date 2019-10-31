#import "MWZDefaultScene.h"
#import "MWZUIConstants.h"

@implementation MWZDefaultScene

- (void)addTo:(UIView *)view {
    self.menuBar = [[MWZMapViewMenuBar alloc] initWithFrame:CGRectZero];
    self.menuBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuBar.delegate = self;
    [view addSubview:self.menuBar];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-view.safeAreaInsets.right - MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:view.safeAreaInsets.left + MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.menuBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    }
}

- (void) setHidden:(BOOL) hidden {
    [self.menuBar setHidden:hidden];
}

- (void)didTapOnDirectionButton {
    [_delegate didTapOnDirectionButton];
}

- (void)didTapOnMenuButton {
    [_delegate didTapOnMenuButton];
}

- (void)didTapOnSearchButton {
    [_delegate didTapOnSearchButton];
}

/*- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }
    return v;
}*/



@end
