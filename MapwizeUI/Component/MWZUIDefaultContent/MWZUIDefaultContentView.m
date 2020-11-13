#import "MWZUIDefaultContentView.h"
#import "MWZUIIconTextButton.h"
#import "MWZUIOpeningHoursUtils.h"
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

-(void)setContentForPlaceDetails:(MWZPlaceDetails*)placeDetails
                 language:(NSString*)language
                  buttons:(NSMutableArray<MWZUIIconTextButton*>*)buttons {
    _placeDetails = placeDetails;
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleTextView.text = [_placeDetails titleForLanguage:language];
    
    [self addSubview:_titleTextView];
    
    [[_titleTextView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[_titleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
    [[_titleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0] setActive:YES];
    
    UIView* lastAnchorView = _titleTextView;
    if ([_placeDetails subtitleForLanguage:language] && [[_placeDetails subtitleForLanguage:language] length] > 0) {
        UILabel* subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitle.translatesAutoresizingMaskIntoConstraints = NO;
        subtitle.textColor = [UIColor darkGrayColor];
        subtitle.font = [subtitle.font fontWithSize:16];
        subtitle.text = [_placeDetails subtitleForLanguage:language];
        [self addSubview:subtitle];
        [[subtitle.heightAnchor constraintEqualToConstant:16] setActive:YES];
        [[subtitle.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
        [[subtitle.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
        [[subtitle.topAnchor constraintEqualToAnchor:lastAnchorView.bottomAnchor constant:8.0] setActive:YES];
        lastAnchorView = subtitle;
    }
    if (_placeDetails.openingHours) {
        UILabel* openingHours = [[UILabel alloc] initWithFrame:CGRectZero];
        openingHours.translatesAutoresizingMaskIntoConstraints = NO;
        openingHours.textColor = [UIColor darkGrayColor];
        openingHours.font = [openingHours.font fontWithSize:16];
        openingHours.text = [MWZUIOpeningHoursUtils getCurrentOpeningStateString:_placeDetails.openingHours];
        [self addSubview:openingHours];
        [[openingHours.heightAnchor constraintEqualToConstant:16] setActive:YES];
        [[openingHours.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
        [[openingHours.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0] setActive:YES];
        [[openingHours.topAnchor constraintEqualToAnchor:lastAnchorView.bottomAnchor constant:8.0] setActive:YES];
        lastAnchorView = openingHours;
    }
    
    UIView* lastAnchorButton = nil;
    for (MWZUIIconTextButton* button in buttons) {
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
        if (lastAnchorButton) {
            [[button.leadingAnchor constraintEqualToAnchor:lastAnchorView.trailingAnchor constant:8.0] setActive:YES];
        }
        else {
            [[button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0] setActive:YES];
        }
        [[button.topAnchor constraintEqualToAnchor:lastAnchorView.bottomAnchor constant:8.0] setActive:YES];
        [[button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
        lastAnchorButton = button;
    }
    if (buttons.count == 0) {
        [[lastAnchorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0] setActive:YES];
    }
}



- (NSMutableArray<MWZUIIconTextButton*>*) buildButtonsForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    NSMutableArray<MWZUIIconTextButton*>* buttons = [[NSMutableArray alloc] init];
    MWZUIIconTextButton* directionButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Direction" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    [buttons addObject:directionButton];
    [directionButton addTarget:self action:@selector(directionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (placeDetails.phone) {
        MWZUIIconTextButton* phoneButton = [[MWZUIIconTextButton alloc] initWithTitle:@"Call" image:[UIImage systemImageNamed:@"phone"] color:_color outlined:YES];
        [buttons addObject:phoneButton];
        [phoneButton addTarget:self action:@selector(phoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return buttons;
}

- (void) directionButtonAction:(UIButton*)button {
    [_delegate didTapOnDirectionButton];
}

- (void) phoneButtonAction:(UIButton*)button {
    [_delegate didTapOnCallButton];
}

- (void) shareButtonAction:(UIButton*)button {
    [_delegate didTapOnShareButton];
}

- (void) websiteButtonAction:(UIButton*)button {
    [_delegate didTapOnWebsiteButton];
}

@end
