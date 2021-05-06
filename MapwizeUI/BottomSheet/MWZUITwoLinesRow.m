//
//  MWZUITextFieldRow.m
//  MapwizeUI
//
//  Created by Etienne Mercier on 03/05/2021.
//  Copyright © 2021 Etienne Mercier. All rights reserved.
//

#import "MWZUITwoLinesRow.h"

@interface MWZUITwoLinesRow ()

@property (nonatomic) UILabel* errorMessageLabel;

@end

@implementation MWZUITwoLinesRow

- (instancetype) initWithImage:(UIImage*)image label:(NSString*)label view:(UIView*)view color:(UIColor*)color
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.color = color;
        self.type = MWZUIFullContentViewComponentRowCustom;
        self.infoAvailable = YES;
        [self setupViewWithImage:image label:label view:view];
    }
    return self;
}

- (void) setupViewWithImage:(UIImage*)image label:(NSString*)label view:(UIView*)view {
    self.image = image;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    UILabel* issueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    issueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setTintColor:self.color];
    [issueLabel setText:label];
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    [self addSubview:issueLabel];
    [[issueLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:16] setActive:YES];
    [[issueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[issueLabel.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor constant:0.0] setActive:YES];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [[view.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:16] setActive:YES];
    [[view.trailingAnchor constraintEqualToAnchor:issueLabel.trailingAnchor constant:-16] setActive:YES];
    [[view.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:16.0] setActive:YES];
    [[view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0] setActive:YES];
    
    _errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _errorMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _errorMessageLabel.textColor = [UIColor redColor];
    [_errorMessageLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_errorMessageLabel];
    [[_errorMessageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[_errorMessageLabel.centerYAnchor constraintEqualToAnchor:issueLabel.centerYAnchor] setActive:YES];
    
}

- (void) setErrorMessage:(NSString*)message {
    [_errorMessageLabel setText:message];
}

@end
