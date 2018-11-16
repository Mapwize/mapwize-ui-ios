#import "MWZComponentDirectionInfo.h"

@implementation MWZComponentDirectionInfo {
    UIImageView* distanceImageView;
    UIImageView* traveltimeImageView;
    UILabel* distanceLabel;
    UILabel* traveltimeLabel;
    UIImage* accessibilityOffImage;
    UIImage* accessibilityOnImage;
    UIImage* traveltimeImage;
    UIView* distanceContentView;
    UIView* traveltimeContentView;
}

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.layer.cornerRadius = 10;
        if (@available(iOS 11.0, *)) {
            self.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner;
        }
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowRadius = 4;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        
        [self setupSubview: color];
    }
    return self;
}
    
- (void) setupSubview:(UIColor*) color {
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    accessibilityOnImage = [UIImage imageNamed:@"accessibilityOn" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOnImage = [accessibilityOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    accessibilityOffImage = [UIImage imageNamed:@"accessibilityOff" inBundle:bundle compatibleWithTraitCollection:nil];
    accessibilityOffImage = [accessibilityOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    traveltimeImage = [UIImage imageNamed:@"clock" inBundle:bundle compatibleWithTraitCollection:nil];
    traveltimeImage = [traveltimeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    distanceContentView = [[UIView alloc] init];
    distanceContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:distanceContentView];
    traveltimeContentView = [[UIView alloc] init];
    traveltimeContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:traveltimeContentView];
    
    [[NSLayoutConstraint constraintWithItem:distanceContentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceContentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceContentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:0.5f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:traveltimeContentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeContentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.5f
                                   constant:0.0f] setActive:YES];
    
    distanceImageView = [[UIImageView alloc] init];
    distanceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [distanceImageView setTintColor:color];
    [distanceImageView setImage:accessibilityOffImage];
    [distanceImageView setContentMode:UIViewContentModeScaleAspectFit];
    [distanceContentView addSubview:distanceImageView];
    
    traveltimeImageView = [[UIImageView alloc] init];
    traveltimeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [traveltimeImageView setImage:traveltimeImage];
    [traveltimeImageView setTintColor:color];
    [traveltimeImageView setContentMode:UIViewContentModeScaleAspectFit];
    [traveltimeContentView addSubview:traveltimeImageView];
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [distanceContentView addSubview:distanceLabel];
    traveltimeLabel = [[UILabel alloc] init];
    traveltimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [traveltimeContentView addSubview:traveltimeLabel];
    
    [[NSLayoutConstraint constraintWithItem:distanceImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:distanceContentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceImageView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:distanceContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:distanceLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:distanceImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:distanceContentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:distanceLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:distanceContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:traveltimeImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:traveltimeContentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeImageView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:traveltimeLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:traveltimeImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:traveltimeContentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:traveltimeLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
}
    
- (void) setInfoWith:(MWZDirection*) direction {
    double traveltime = direction.traveltime / 60;
    if (traveltime == 0.0) {
        traveltime = 1.0;
    }
    traveltimeLabel.text = [NSString stringWithFormat:@"%.0f min", traveltime];
    double distance = direction.distance;
    distance = distance*1000/1000;
    NSMeasurement* measurment = [[NSMeasurement alloc] initWithDoubleValue:distance unit:NSUnitLength.meters];
    NSMeasurementFormatter* formatter = [[NSMeasurementFormatter alloc] init];
    formatter.unitOptions = NSMeasurementFormatterUnitOptionsNaturalScale;
    formatter.numberFormatter.maximumFractionDigits = 0;
    NSString* localizedString = [formatter stringFromMeasurement:measurment];
    distanceLabel.text = localizedString;
    
    if (@available(iOS 11.0, *)) {
        [self animateTo:64.0f + self.safeAreaInsets.bottom];
    } else {
        [self animateTo:64.0f];
    }
}
    
- (void) close {
    [self animateTo:0.0f];
}
    
- (void) animateTo:(CGFloat) height {
    for (NSLayoutConstraint* c in self.constraints) {
        if (c.firstAttribute == NSLayoutAttributeHeight) {
            [self.superview layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                c.constant = height;
                [self.superview layoutIfNeeded];
                [self layoutIfNeeded];
            }];
        }
    }
    
}

@end
