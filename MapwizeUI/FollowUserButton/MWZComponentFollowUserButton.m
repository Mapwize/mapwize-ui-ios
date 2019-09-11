#import "MWZComponentFollowUserButton.h"
#import <MapwizeForMapbox/MapwizeForMapbox.h>
#import "MWZComponentFollowUserButtonDelegate.h"
#import "MWZComponentColors.h"

@interface MWZComponentFollowUserButton ()

@property (nonatomic) UIImage* imageNone;
@property (nonatomic) UIImage* imageFollow;
@property (nonatomic) UIImage* imageFollowHeading;

@end

@implementation MWZComponentFollowUserButton

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        _imageNone = [UIImage imageNamed:@"followOff" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        _imageFollow = [UIImage imageNamed:@"followOff" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        _imageFollow = [MWZComponentColors tintedBackgroundImageWithImage:_imageFollow tint:color];
        _imageFollowHeading = [UIImage imageNamed:@"followHeading" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        _imageFollowHeading = [MWZComponentColors tintedBackgroundImageWithImage:_imageFollowHeading tint:color];
        [self setImage:_imageNone forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(buttonAction)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

-(void)buttonAction {
    if ([self.delegate followUserButtonRequiresUserLocation:self] == nil) {
        [self.delegate didTapWithoutLocation];
        return;
    }
    MWZFollowUserMode mode = [self.delegate followUserButtonRequiresFollowUserMode:self];
    switch (mode) {
        case NONE:
            [self.delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER];
            break;
        case FOLLOW_USER:
            [self.delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER_AND_HEADING];
            break;
        case FOLLOW_USER_AND_HEADING:
            [self.delegate followUserButton:self didChangeFollowUserMode:FOLLOW_USER];
            break;
        default:
            break;
    }
}

- (void) setFollowUserMode:(MWZFollowUserMode) mode {
    switch (mode) {
        case NONE:
            [self setImage:self.imageNone forState:UIControlStateNormal];
            break;
        case FOLLOW_USER:
            [self setImage:self.imageFollow forState:UIControlStateNormal];
            break;
        case FOLLOW_USER_AND_HEADING:
            [self setImage:self.imageFollowHeading forState:UIControlStateNormal];
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
