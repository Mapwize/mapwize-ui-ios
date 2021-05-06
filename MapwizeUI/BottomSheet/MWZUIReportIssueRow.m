//
//  MWZUIReportIssueRow.m
//  MapwizeUI
//
//  Created by Etienne Mercier on 23/04/2021.
//  Copyright © 2021 Etienne Mercier. All rights reserved.
//

#import "MWZUIReportIssueRow.h"

@implementation MWZUIReportIssueRow

- (instancetype) initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        self.type = MWZUIFullContentViewComponentRowSchedule;
        [self setupView];
    }
    return self;
}

- (void) setupView {
    self.image = [UIImage imageNamed:@"calendar" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    UILabel* bookingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bookingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setTintColor:self.color];
    [bookingLabel setFont:[UIFont systemFontOfSize:14]];
    [bookingLabel setText:@"Information is wrong? Tell us about it!"];
    
//    [self addSubview:imageView];
//    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
//    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
//    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
//    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    
//    [self addSubview:bookingLabel];
//    [[bookingLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:32] setActive:YES];
//    [[bookingLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
//    [[bookingLabel.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor constant:0.0] setActive:YES];
//
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [button setTitle:@"Report an issue" forState:UIControlStateNormal];
    [button setTitleColor:self.color forState:UIControlStateNormal];
    [[button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:32] setActive:YES];
    [[button.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-32] setActive:YES];
    [[button.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0] setActive:YES];
    [[button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0] setActive:YES];
    [[button.heightAnchor constraintEqualToConstant:56] setActive:YES];
    [button addTarget:self
                   action:@selector(openIssueController)
         forControlEvents:UIControlEventTouchUpInside];
    
//    [[button.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:16.0] setActive:YES];
//    [[button.heightAnchor constraintEqualToConstant:130] setActive:YES];
//    [[button.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
//    [[button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
//    [[button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0] setActive:YES];
    
}

- (void) openIssueController {
    [_delegate didTapOnReportIssue];
}

@end
