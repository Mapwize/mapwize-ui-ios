#import "MWZUIPaddingTextField.h"

@implementation MWZUIPaddingTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}

@end
