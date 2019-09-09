#import "MWZComponentFollowUserButton.h"
#import <MapwizeForMapbox/MapwizeForMapbox.h>
#import "MWZComponentFollowUserButtonDelegate.h"
#import "MWZComponentColors.h"

@implementation MWZComponentFollowUserButton {
    UIImage* imageNone;
    UIImage* imageFollow;
    UIImage* imageFollowHeading;
}

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        imageNone = [UIImage imageNamed:@"followOff" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        imageFollow = [UIImage imageNamed:@"followOff" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        imageFollow = [MWZComponentColors tintedBackgroundImageWithImage:imageFollow tint:color];
        imageFollowHeading = [UIImage imageNamed:@"followHeading" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        imageFollowHeading = [MWZComponentColors tintedBackgroundImageWithImage:imageFollowHeading tint:color];
        [self setImage:imageNone forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(buttonAction)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

-(void)buttonAction {
    if ([_delegate followUserButtonRequiresUserLocation:self] == nil) {
        [_delegate didTapWithoutLocation];
        return;
    }
    MWZFollowUserMode mode = [_delegate followUserButtonRequiresFollowUserMode:self];
    switch (mode) {
        case NONE:
            [_delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER];
            break;
        case FOLLOW_USER:
            [_delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER_AND_HEADING];
            break;
        case FOLLOW_USER_AND_HEADING:
            [_delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER];
            break;
        default:
            break;
    }
}

- (void) setFollowUserMode:(MWZFollowUserMode) mode {
    switch (mode) {
        case NONE:
            [self setImage:imageNone forState:UIControlStateNormal];
            break;
        case FOLLOW_USER:
            [self setImage:imageFollow forState:UIControlStateNormal];
            break;
        case FOLLOW_USER_AND_HEADING:
            [self setImage:imageFollowHeading forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds = false;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = rect.size.height/2;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
}

@end
