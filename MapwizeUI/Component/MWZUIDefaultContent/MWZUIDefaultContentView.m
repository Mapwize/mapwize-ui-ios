#import "MWZUIDefaultContentView.h"
#import "MWZUIIconTextButton.h"

@interface MWZUIDefaultContentView ()

@property (nonatomic) UILabel* titleTextView;
@property (nonatomic) UILabel* floorTextView;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UIButton* callButton;

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
    
    UIView* lastAnchorView = self;
    for (MWZUIIconTextButton* button in buttons) {
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
        [[button.leadingAnchor constraintEqualToAnchor:lastAnchorView.leadingAnchor constant:8.0] setActive:YES];
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
    _directionButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Direction" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    [buttons addObject:_directionButton];
    
    return buttons;
}

- (void)setMock:(MWZUIPlaceMock *)mock {
    _mock = mock;
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _titleTextView.text = mock.title;
    
    [self addSubview:_titleTextView];
    
    [[_titleTextView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[_titleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[_titleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0] setActive:YES];
    
    _directionButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Direction" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    _directionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_directionButton];
    [[_directionButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[_directionButton.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:8.0] setActive:YES];
    [[_directionButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
    
    if (mock.phoneNumber) {
        _callButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Call" image:[UIImage systemImageNamed:@"phone.fill"] color:_color outlined:YES];
        _callButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_callButton];
        [[_callButton.leadingAnchor constraintEqualToAnchor:_directionButton.trailingAnchor constant:8.0] setActive:YES];
        [[_callButton.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:8.0] setActive:YES];
        [[_callButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
    }
}

@end
