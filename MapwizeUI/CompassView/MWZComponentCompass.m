#import <Mapbox/Mapbox.h>
#import "MWZComponentCompass.h"
#import "MWZComponentCompassDelegate.h"

@implementation MWZComponentCompass

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCompassTap:)]];
        self.accessibilityTraits = UIAccessibilityTraitButton;
        self.alpha = 0;
        self.layer.masksToBounds = false;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowRadius = 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
    }
    return self;
}

- (void)handleCompassTap:(UITapGestureRecognizer*)gesture {
    [self.delegate didPress:self];
}

- (void) updateCompass:(CLLocationDirection) direction {
    CLLocationDirection plateDirection = -direction;
    self.transform = CGAffineTransformMakeRotation(MGLRadiansFromDegrees(plateDirection));
    
    self.isAccessibilityElement = direction > 0;
    
    if (direction > 0 && self.alpha < 1)
    {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             self.alpha = 1;
         }
                         completion:nil];
    }
    else if (direction == 0 && self.alpha > 0)
    {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             self.alpha = 0;
         }
                         completion:nil];
    }
}

@end
