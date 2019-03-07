#import "MWZComponentQrCodeButton.h"
#import "MWZComponentQrCodeButtonDelegate.h"

@implementation MWZComponentQrCodeButton

- (instancetype) init {
    self = [super init];
    if (self) {
        UIImage* image = [UIImage imageNamed:@"qr_code" inBundle:[NSBundle bundleForClass:MWZComponentQrCodeButton.class] compatibleWithTraitCollection:nil];
        [self setImage:image forState:UIControlStateNormal];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.adjustsImageWhenHighlighted = NO;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(buttonAction)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

-(void)buttonAction {
    [_delegate didTapOn:self];
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
