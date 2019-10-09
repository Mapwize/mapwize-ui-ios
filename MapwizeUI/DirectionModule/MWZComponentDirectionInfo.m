#import "MWZComponentDirectionInfo.h"

@interface MWZComponentDirectionInfo ()

@property (nonatomic) UIImageView* distanceImageView;
@property (nonatomic) UIImageView* traveltimeImageView;
@property (nonatomic) UILabel* distanceLabel;
@property (nonatomic) UILabel* traveltimeLabel;
@property (nonatomic) UIImage* accessibilityOffImage;
@property (nonatomic) UIImage* accessibilityOnImage;
@property (nonatomic) UIImage* traveltimeImage;
@property (nonatomic) UIView* distanceContentView;
@property (nonatomic) UIView* traveltimeContentView;

@end

@implementation MWZComponentDirectionInfo

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
    self.accessibilityOnImage = [UIImage imageNamed:@"accessibilityOn" inBundle:bundle compatibleWithTraitCollection:nil];
    self.accessibilityOnImage = [self.accessibilityOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.accessibilityOffImage = [UIImage imageNamed:@"accessibilityOff" inBundle:bundle compatibleWithTraitCollection:nil];
    self.accessibilityOffImage = [self.accessibilityOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.traveltimeImage = [UIImage imageNamed:@"clock" inBundle:bundle compatibleWithTraitCollection:nil];
    self.traveltimeImage = [self.traveltimeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.distanceContentView = [[UIView alloc] init];
    self.distanceContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.distanceContentView];
    self.traveltimeContentView = [[UIView alloc] init];
    self.traveltimeContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.traveltimeContentView];
    
    [[NSLayoutConstraint constraintWithItem:self.distanceContentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceContentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceContentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:0.5f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:16.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.5f
                                   constant:0.0f] setActive:YES];
    
    self.distanceImageView = [[UIImageView alloc] init];
    self.distanceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.distanceImageView setTintColor:color];
    [self.distanceImageView setImage:self.accessibilityOffImage];
    [self.distanceImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.distanceContentView addSubview:self.distanceImageView];
    
    self.traveltimeImageView = [[UIImageView alloc] init];
    self.traveltimeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.traveltimeImageView setImage:self.traveltimeImage];
    [self.traveltimeImageView setTintColor:color];
    [self.traveltimeImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.traveltimeContentView addSubview:self.traveltimeImageView];
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.distanceContentView addSubview:self.distanceLabel];
    self.traveltimeLabel = [[UILabel alloc] init];
    self.traveltimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.traveltimeContentView addSubview:self.traveltimeLabel];
    
    [[NSLayoutConstraint constraintWithItem:self.distanceImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.distanceContentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceImageView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.distanceContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.distanceLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.distanceImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.distanceContentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.distanceLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.distanceContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.traveltimeImageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeImageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeImageView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeImageView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.traveltimeLabel
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:32.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.traveltimeImageView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:8.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeLabel
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.traveltimeLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.traveltimeContentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0f] setActive:YES];
}

- (void) setInfoWith:(double) directionTravelTime directionDistance:(double) directionDistance {
    double traveltime = directionTravelTime / 60;
    if (traveltime <= 1.0) {
        traveltime = 1.0;
    }
    self.traveltimeLabel.text = [NSString stringWithFormat:@"%.0f min", traveltime];
    double distance = directionDistance;
    distance = distance*1000/1000;
    NSMeasurement* measurment = [[NSMeasurement alloc] initWithDoubleValue:distance unit:NSUnitLength.meters];
    NSMeasurementFormatter* formatter = [[NSMeasurementFormatter alloc] init];
    formatter.unitOptions = NSMeasurementFormatterUnitOptionsProvidedUnit;
    formatter.numberFormatter.maximumFractionDigits = 0;
    NSString* localizedString = [formatter stringFromMeasurement:measurment];
    self.distanceLabel.text = localizedString;
    
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
