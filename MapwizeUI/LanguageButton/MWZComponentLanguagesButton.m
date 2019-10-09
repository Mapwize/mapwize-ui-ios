#import "MWZComponentLanguagesButton.h"
#import "MWZComponentLanguagesButtonDelegate.h"

@interface MWZComponentLanguagesButton ()

@property (nonatomic) NSArray<NSString*>* languages;

@end

@implementation MWZComponentLanguagesButton
- (instancetype) init {
    self = [super init];
    if (self) {
        UIImage* image = [UIImage imageNamed:@"languages" inBundle:[NSBundle bundleForClass:MWZComponentLanguagesButton.class] compatibleWithTraitCollection:nil];
        [self setImage:image forState:UIControlStateNormal];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.adjustsImageWhenHighlighted = NO;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(buttonAction)];
        [self addGestureRecognizer:singleFingerTap];
        [self setHidden:YES];
    }
    return self;
}

- (void) mapwizeDidEnterInVenue:(MWZVenue*) venue {
    self.languages = venue.supportedLanguages;
    if (self.languages.count > 1) {
        [self setHidden:NO];
    }
    else {
        [self setHidden:YES];
    }
}

- (void) mapwizeDidExitVenue {
    self.languages = @[];
    [self setHidden:YES];
}

-(void)buttonAction {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Languages", "")
                                                                   message:NSLocalizedString(@"Choose your preferred language", "")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (NSString* language in self.languages) {
        NSLocale* locale = [NSLocale localeWithLocaleIdentifier:language];
        NSString* displayLanguage = [locale displayNameForKey:NSLocaleIdentifier value:language];
        
        [alert addAction:[UIAlertAction actionWithTitle:displayLanguage.capitalizedString
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if (self.delegate) {
                                                        [self.delegate didSelectLanguage:language];
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
