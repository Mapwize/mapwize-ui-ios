#import "MWZUIBookingView.h"
#import "MWZUIBookingGridView.h"

@import MapwizeSDK;

@implementation MWZUIBookingView

static double gridWidth = 25;

- (instancetype) initWithFrame:(CGRect)frame placeDetails:(MWZPlaceDetails*)placeDetails color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        self.type = MWZUIFullContentViewComponentRowSchedule;
        self.infoAvailable = placeDetails.events && placeDetails.events.count > 0;
        [self setupViewWithPlaceDetails:placeDetails];
    }
    return self;
}

- (void) setupViewWithPlaceDetails:(MWZPlaceDetails*)placeDetails {
    self.image = [UIImage systemImageNamed:@"calendar.badge.clock"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setImage:[self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    UILabel* bookingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bookingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.infoAvailable) {
        [imageView setTintColor:self.color];
        [bookingLabel setFont:[UIFont systemFontOfSize:14]];
        BOOL isOccupied = [self isOccupied:placeDetails];
        [bookingLabel setText:isOccupied?@"Currently occupied":@"Currently available"];
    }
    else {
        [imageView setTintColor:[UIColor darkGrayColor]];
        UIFontDescriptor * fontD = [bookingLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        bookingLabel.font = [UIFont fontWithDescriptor:fontD size:14];
        bookingLabel.textColor = [UIColor darkGrayColor];
        [bookingLabel setText:@"Schedule not available"];
    }
    [self addSubview:imageView];
    [[imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[imageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[imageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    
    [self addSubview:bookingLabel];
    [[bookingLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:32] setActive:YES];
    [[bookingLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[bookingLabel.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor constant:0.0] setActive:YES];
    
    if (self.infoAvailable) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_scrollView];
        [[_scrollView.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:16.0] setActive:YES];
        [[_scrollView.heightAnchor constraintEqualToConstant:130] setActive:YES];
        [[_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
        [[_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
        [[_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0] setActive:YES];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
        NSInteger hour = [components hour];
        NSInteger min = [components minute];
        double time = hour + min/60.0;
        
        MWZUIBookingGridView* v = [[MWZUIBookingGridView alloc] initWithFrame:CGRectZero gridWidth:gridWidth color:self.color];
        [_scrollView addSubview:v];
        _scrollView.contentSize = v.frame.size;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [v setCurrentTime:time events:placeDetails.events];
        [_scrollView scrollRectToVisible:CGRectMake(7*gridWidth-20, 0, 10, 10) animated:NO];
    }
    else {
        [[imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16] setActive:YES];
    }
}

- (BOOL) isOccupied:(MWZPlaceDetails*)placeDetails {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    double time = hour + min/60.0;
    
    for (MWZPlaceDetailsEvent* event in placeDetails.events) {
        if (event.start.doubleValue<time && event.end.doubleValue>time) {
            return YES;
        }
    }
    
    return NO;
}

@end
