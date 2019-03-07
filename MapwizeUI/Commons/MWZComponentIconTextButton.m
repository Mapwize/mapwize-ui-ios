#import "MWZComponentIconTextButton.h"

@implementation MWZComponentIconTextButton {
    UIImageView* imageView;
    UILabel* labelView;
    UIColor* color;
}

- (instancetype)initWithTitle:(NSString*) text imageName:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined {
    self = [super init];
    if (self) {
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        if (outlined) {
            [imageView setTintColor:color];
        }
        else {
            [imageView setTintColor:[UIColor whiteColor]];
        }
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:16.f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:16.f] setActive:YES];
        
        labelView = [[UILabel alloc] init];
        labelView.translatesAutoresizingMaskIntoConstraints = NO;
        [labelView setFont:[UIFont systemFontOfSize:14]];
        if (outlined) {
            [labelView setTextColor:[UIColor darkGrayColor]];
        }
        else {
            [labelView setTextColor:[UIColor whiteColor]];
        }
        [self addSubview:labelView];
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:imageView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:12.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:12.f] setActive:YES];
        
        
        self.layer.masksToBounds = NO;
        if (outlined) {
            self.layer.backgroundColor = [UIColor whiteColor].CGColor;
            self.layer.borderColor = [UIColor grayColor].CGColor;
        }
        else {
            self.layer.backgroundColor = color.CGColor;
            self.layer.borderColor = color.CGColor;
        }
        self.layer.cornerRadius = 18.0f;
        self.layer.borderWidth = 0.5f;
        [imageView setImage:image];
        [labelView setText:text];
    }
    return self;
}

- (void) setup {
    
    
    
}

@end
