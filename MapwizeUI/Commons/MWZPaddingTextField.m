#import "MWZPaddingTextField.h"

@implementation MWZPaddingTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}

@end
