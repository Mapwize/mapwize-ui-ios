//
//  MWZUIRoundedButtonIconText.m
//  BottomSheet
//
//  Created by Etienne on 30/09/2020.
//

#import "MWZUIFullContentViewComponentButton.h"

@implementation MWZUIFullContentViewComponentButton {
    UIView* imageContainerView;
    UIImageView* imageView;
    UILabel* labelView;
    UIColor* color;
}

- (instancetype)initWithTitle:(NSString*) text image:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined {
    self = [super init];
    if (self) {
        imageContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        imageContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        imageContainerView.userInteractionEnabled = NO;
        [self addSubview:imageContainerView];
        [[imageContainerView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[imageContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[imageContainerView.heightAnchor constraintEqualToConstant:48] setActive:YES];
        [[imageContainerView.widthAnchor constraintEqualToConstant:48] setActive:YES];
        imageContainerView.layer.masksToBounds = NO;
        if (outlined) {
            imageContainerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
            imageContainerView.layer.borderColor = color.CGColor;
        }
        else {
            imageContainerView.layer.backgroundColor = color.CGColor;
            imageContainerView.layer.borderColor = color.CGColor;
        }
        imageContainerView.layer.cornerRadius = 24;
        imageContainerView.layer.borderWidth = 0.5f;
        
        
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        if (outlined) {
            [imageView setTintColor:color];
        }
        else {
            [imageView setTintColor:[UIColor whiteColor]];
        }
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageContainerView addSubview:imageView];
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:imageContainerView
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:imageView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:imageContainerView
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
        labelView.userInteractionEnabled = NO;
        [labelView setFont:[UIFont systemFontOfSize:14]];
        [labelView setTextColor:color];
        [self addSubview:labelView];
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:12.f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:labelView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:imageContainerView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8] setActive:YES];
        
        [[labelView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0] setActive:YES];
        [[labelView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0] setActive:YES];
        labelView.textAlignment = NSTextAlignmentCenter;
        [imageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [labelView setText:text];
    }
    return self;
}


@end
