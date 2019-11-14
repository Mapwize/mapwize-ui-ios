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

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.directionHeader setFromText:text asPlaceHolder:asPlaceHolder];
}

-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder {
    [self.directionHeader setToText:text asPlaceHolder:asPlaceHolder];
}

-(void) setAccessibleMode:(BOOL) isAccessible {
    [self.directionHeader setAccessibleMode:isAccessible];
}

- (void)directionHeaderDidTapOnBackButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnBackButton:self];
}

- (void)directionHeaderDidTapOnFromButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnFromButton:self];
}

- (void)directionHeaderDidTapOnToButton:(MWZDirectionHeader *)directionHeader {
    [_delegate directionSceneDidTapOnToButton:self];
}

- (void) directionHeaderAccessibilityModeDidChange:(BOOL) isAccessible {
    [_delegate directionSceneAccessibilityModeDidChange:isAccessible];
}

@end
