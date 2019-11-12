#import "MWZDirectionScene.h"

@implementation MWZDirectionScene

- (void) addTo:(UIView*) view {
    self.directionHeader = [[MWZDirectionHeader alloc] initWithFrame:CGRectZero];
    self.directionHeader.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionHeader.delegate = self;
    [view addSubview:self.directionHeader];
    
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.directionHeader
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
}

- (void) setHidden:(BOOL) hidden {
    [self.directionHeader setHidden:hidden];
}

- (void)directionHeaderDidTapOnBackButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnBackButton:self];
}

@end
