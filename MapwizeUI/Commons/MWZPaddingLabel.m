#import "MWZPaddingLabel.h"

@implementation MWZPaddingLabel

- (void)drawTextInRect:(CGRect)uiLabelRect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(uiLabelRect, UIEdgeInsetsMake(_topInset, _leftInset, _bottomInset, _rightInset))];
}

@end
