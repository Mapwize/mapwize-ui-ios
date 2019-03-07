#import "MWZComponentBorderedTextField.h"

@implementation MWZComponentBorderedTextField

- (instancetype) init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f].CGColor;
    }
    return self;
}
    
- (CGRect) textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 5.0f))];
}
    
- (CGRect) editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f))];
}
    
@end
