#import "MWZComponentCurrentLocationView.h"

@implementation MWZComponentCurrentLocationView {
    UIImageView* icon;
    UILabel* label;
}
    
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        NSBundle* bundle = [NSBundle bundleForClass:self.class];
        UIImage* iconImage = [UIImage imageNamed:@"followOff" inBundle:bundle compatibleWithTraitCollection:nil];
        icon = [[UIImageView alloc] init];
        icon.translatesAutoresizingMaskIntoConstraints = NO;
        [icon setImage:iconImage];
        [self addSubview:icon];
        label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = NSLocalizedString(@"Current location", "");
        [self addSubview:label];
        [[NSLayoutConstraint constraintWithItem:icon
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:24.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:icon
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:24.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:icon
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:icon
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:icon
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:24.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-16.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:icon
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:16.0f] setActive:YES];
    }
    return self;
}


    
@end
