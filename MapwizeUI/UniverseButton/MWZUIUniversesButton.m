#import "MWZUIUniversesButton.h"
#import "MWZUIUniversesButtonDelegate.h"

@interface MWZUIUniversesButton ()

@property (nonatomic) NSArray<MWZUniverse*>* universes;

@end

@implementation MWZUIUniversesButton

- (instancetype) init {
    self = [super init];
    if (self) {
        _universes = @[];
        UIImage* image = [UIImage imageNamed:@"universe" inBundle:[NSBundle bundleForClass:MWZUIUniversesButton.class] compatibleWithTraitCollection:nil];
        [self setImage:image forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(12, 12,12, 12);
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.adjustsImageWhenHighlighted = NO;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(buttonAction)];
        [self addGestureRecognizer:singleFingerTap];
        [self setHidden:YES];
    }
    return self;
}

- (void) showIfNeeded {
    [self setHidden:self.universes.count <= 1];
}

- (void) mapwizeAccessibleUniversesDidChange:(NSArray<MWZUniverse*>*) accessibleUniverses {
    self.universes = accessibleUniverses;
    [self setHidden:accessibleUniverses.count <= 1];
}

-(void)buttonAction {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Universes", "")
                                                                   message:NSLocalizedString(@"Choose a universe to display it on the map", "")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (MWZUniverse* universe in self.universes) {
        [alert addAction:[UIAlertAction actionWithTitle:universe.name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if (self.delegate) {
                                                        [self.delegate didSelectUniverse:universe];
                                                    }
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", "")
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    
    [[self parentViewController] presentViewController:alert animated:YES completion:nil];
    
}

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
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
