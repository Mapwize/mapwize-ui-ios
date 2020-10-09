#import "MWZUIDefaultContentView.h"
#import "MWZUIIconTextButton.h"

@interface MWZUIDefaultContentView ()

@property (nonatomic) UILabel* titleTextView;
@property (nonatomic) UILabel* floorTextView;

@end

@implementation MWZUIDefaultContentView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        //[self initViews];
    }
    return self;
}

- (void)setPlacePreview:(MWZPlacePreview *)placePreview {
    _placePreview = placePreview;
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _titleTextView.text = placePreview.title;
    
    [self addSubview:_titleTextView];
    
    [[_titleTextView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[_titleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[_titleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0] setActive:YES];
    
    UIActivityIndicatorView* progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:progressView];
    [progressView startAnimating];
    [[progressView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0.0] setActive:YES];
    [[progressView.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:16.0] setActive:YES];
    [[progressView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16.0] setActive:YES];
}

-(void)setContentForPlace:(MWZPlace*)place
                 language:(NSString*)language
                  buttons:(NSMutableArray<MWZUIIconTextButton*>*)buttons {
    _place = place;
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleTextView.text = [place titleForLanguage:language];
    
    [self addSubview:_titleTextView];
    
    [[_titleTextView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[_titleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[_titleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0] setActive:YES];
    
    UIView* lastAnchorView = nil;
    for (MWZUIIconTextButton* button in buttons) {
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
        if (lastAnchorView) {
            [[button.leadingAnchor constraintEqualToAnchor:lastAnchorView.trailingAnchor constant:8.0] setActive:YES];
        }
        else {
            [[button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
        }
        [[button.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:8.0] setActive:YES];
        [[button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
        lastAnchorView = button;
    }
    if (buttons.count == 0) {
        [[_titleTextView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
    }
}



- (NSMutableArray<MWZUIIconTextButton*>*) buildButtonsForPlace:(MWZPlace*)place {
    NSMutableArray<MWZUIIconTextButton*>* buttons = [[NSMutableArray alloc] init];
    MWZUIIconTextButton* directionButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Direction" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    [buttons addObject:directionButton];
    
    if (place.phone) {
        MWZUIIconTextButton* directionButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Call" image:[UIImage systemImageNamed:@"phone"] color:_color outlined:YES];
        [buttons addObject:directionButton];
    }
    
    return buttons;
}

@end
