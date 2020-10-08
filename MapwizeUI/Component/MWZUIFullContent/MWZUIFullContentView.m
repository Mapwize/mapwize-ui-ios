//
//  MWZUIFullContentView.m
//  BottomSheet
//
//  Created by Etienne on 28/09/2020.
//

#import "MWZUIFullContentView.h"
#import "MWZUIFullContentViewComponentButton.h"
#import "MWZUIPlaceMock.h"
#import "MWZUIOpeningHoursView.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIBookingView.h"
#import "MWZUIBottomSheet.h"

@interface MWZUIFullContentView ()

@property (nonatomic) UILabel* titleTextView;
@property (nonatomic) UILabel* subtitleTextView;
@property (nonatomic) UIStackView* headerButtonStackView;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UIButton* callButton;
@property (nonatomic) UIButton* shareButton;
@property (nonatomic) UIButton* webSiteButton;
@property (nonatomic) MWZUIOpeningHoursView* openingHoursView;
@property (nonatomic) UILabel* phoneTextView;

@end

@implementation MWZUIFullContentView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        _color = color;
    }
    return self;
}

-(void)setContentForPlace:(MWZPlace*)place
                 language:(NSString*)language
                  buttons:(NSArray<MWZUIFullContentViewComponentButton*>*)buttons
                     rows:(NSArray<MWZUIFullContentViewComponentRow*>*)rows {
    _place = place;
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleTextView.text = [place titleForLanguage:language];
    [self addSubview:_titleTextView];
    [[_titleTextView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[_titleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0] setActive:YES];
    [[_titleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0] setActive:YES];
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:16.0] setActive:YES];
    [[_titleTextView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32] setActive:YES];
    
    _subtitleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleTextView.font=[_subtitleTextView.font fontWithSize:16];
    [_subtitleTextView setTextColor:[UIColor darkGrayColor]];
    _subtitleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _subtitleTextView.text = [place subtitleForLanguage:language];
    _subtitleTextView.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleTextView.numberOfLines = 0;
    [self addSubview:_subtitleTextView];
    [[_subtitleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0] setActive:YES];
    [[_subtitleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0] setActive:YES];
    [[_subtitleTextView.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:8.0] setActive:YES];
    [[_subtitleTextView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32] setActive:YES];

    UIView* topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    topSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:topSeparator];
    topSeparator.backgroundColor = [UIColor lightGrayColor];
    [[topSeparator.heightAnchor constraintEqualToConstant:0.3] setActive:YES];
    [[topSeparator.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[topSeparator.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[topSeparator.topAnchor constraintEqualToAnchor:_subtitleTextView.bottomAnchor constant:16.0] setActive:YES];
    [[topSeparator.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    
    _headerButtonStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _headerButtonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerButtonStackView.distribution = UIStackViewDistributionFillEqually;
    _headerButtonStackView.alignment = UIStackViewAlignmentLeading;
    _headerButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    [self addSubview:_headerButtonStackView];
    [[_headerButtonStackView.topAnchor constraintEqualToAnchor:topSeparator.bottomAnchor constant:16.0] setActive:YES];
    [[_headerButtonStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0] setActive:YES];
    [[_headerButtonStackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-16.0] setActive:YES];
    [[_headerButtonStackView.heightAnchor constraintEqualToConstant:70] setActive:YES];
    
    for (MWZUIFullContentViewComponentButton* button in buttons) {
        [_headerButtonStackView addArrangedSubview:button];
    }
    
    if (buttons.count == 4) {
        [[_headerButtonStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32] setActive:YES];
    }
    else {
        [[_headerButtonStackView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor constant:-32] setActive:YES];
    }
    
    UIView* lastView = [self addSeparatorBelow:_headerButtonStackView marginTop:16];
    
    for (MWZUIFullContentViewComponentRow* row in rows) {
        lastView = [self addRow:row below:lastView];
        if ([rows indexOfObject:row] < rows.count - 1) {
            lastView = [self addSeparatorBelow:lastView marginTop:0];
        }
    }
    [[lastView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16] setActive:YES];
}

- (NSMutableArray<MWZUIFullContentViewComponentButton*>*) buildHeaderButtonsForPlace:(MWZPlace*)place language:(NSString*)language {
    NSMutableArray<MWZUIFullContentViewComponentButton*>* buttons = [[NSMutableArray alloc] init];
    MWZUIFullContentViewComponentButton* directionButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"DIRECTIONS" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    [buttons addObject:directionButton];
    if (NO) {//place.phoneNumber) {
        MWZUIFullContentViewComponentButton* phoneButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"CALL" image:[UIImage systemImageNamed:@"phone.fill"] color:_color outlined:YES];
        [buttons addObject:phoneButton];
    }
    if (NO) {//place.website) {
        MWZUIFullContentViewComponentButton* websiteButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"WEBSITE" image:[UIImage systemImageNamed:@"network"] color:_color outlined:YES];
        [buttons addObject:websiteButton];
    }
    if (NO) {//place.sharable) {
        MWZUIFullContentViewComponentButton* shareButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"SHARE" image:[UIImage systemImageNamed:@"square.and.arrow.up"] color:_color outlined:YES];
        [buttons addObject:shareButton];
    }
    return buttons;
}

- (NSMutableArray<MWZUIFullContentViewComponentRow*>*) buildContentRowsForPlace:(MWZPlace*)place language:(NSString*)language {
    NSMutableArray<MWZUIFullContentViewComponentRow*>* rows = [[NSMutableArray alloc] init];
    NSMutableArray<MWZUIFullContentViewComponentRow*>* unfilledRow = [[NSMutableArray alloc] init];
    if (NO) {//place.openingHours) {
        MWZUIFullContentViewComponentRow* openRow = [self getOpeningHoursRowForMock:place];
        [rows addObject:openRow];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getOpeningHoursRowForMock:nil];
        [unfilledRow addObject:row];
    }
    if (NO) {//place.phoneNumber) {
        MWZUIFullContentViewComponentRow* row = [self getPhoneRowForMock:place];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getPhoneRowForMock:nil];
        [unfilledRow addObject:row];
    }
    if (NO) {//place.website) {
        MWZUIFullContentViewComponentRow* row = [self getWebsiteRowForMock:place];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getWebsiteRowForMock:nil];
        [unfilledRow addObject:row];
    }
    if (NO) {//place.calendarEvents) {
        MWZUIFullContentViewComponentRow* row = [self getBookingRowForMock:place];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getBookingRowForMock:nil];
        [unfilledRow addObject:row];
    }
    [rows addObjectsFromArray:unfilledRow];
    return rows;
}

- (UIView*) addRow:(MWZUIFullContentViewComponentRow*)componentRow below:(UIView*)view {
    [self addSubview:componentRow];
    componentRow.translatesAutoresizingMaskIntoConstraints = NO;
    [[componentRow.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:0.0] setActive:YES];
    [[componentRow.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0] setActive:YES];
    [[componentRow.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0] setActive:YES];
    [[componentRow.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    return componentRow;
}

- (MWZUIFullContentViewComponentRow*) getBookingRowForMock:(MWZUIPlaceMock*)mock {
    return [[MWZUIBookingView alloc] initWithFrame:CGRectZero mock:mock color:_color];
}

- (UIView*) addBookingRowBelow:(UIView*) view {
    
    UIView* bookingRow = [[UIView alloc] initWithFrame:CGRectZero];
    bookingRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bookingRow];
    [[bookingRow.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:0.0] setActive:YES];
    [[bookingRow.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0] setActive:YES];
    [[bookingRow.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0] setActive:YES];
    
    UIImageView* bookingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bookingImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [bookingImageView setImage:[[UIImage systemImageNamed:@"calendar.badge.clock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [bookingImageView setTintColor:_color];
    [bookingRow addSubview:bookingImageView];
    [[bookingImageView.leadingAnchor constraintEqualToAnchor:bookingRow.leadingAnchor constant:16] setActive:YES];
    [[bookingImageView.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:16.0] setActive:YES];
    [[bookingImageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[bookingImageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    UILabel* bookingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bookingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [bookingLabel setFont:[UIFont systemFontOfSize:14]];
    BOOL isOccupied = [self isOccupied:_mock];
    [bookingLabel setText:isOccupied?@"Currently occupied":@"Currently available"];
    
    [bookingRow addSubview:bookingLabel];
    [[bookingLabel.leadingAnchor constraintEqualToAnchor:bookingImageView.trailingAnchor constant:36] setActive:YES];
    [[bookingLabel.trailingAnchor constraintEqualToAnchor:bookingRow.trailingAnchor] setActive:YES];
    [[bookingLabel.centerYAnchor constraintEqualToAnchor:bookingImageView.centerYAnchor constant:0.0] setActive:YES];
    
    MWZUIBookingView* gridView = [[MWZUIBookingView alloc] initWithFrame:CGRectZero mock:_mock color:_color];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:gridView];
    [[gridView.topAnchor constraintEqualToAnchor:bookingImageView.bottomAnchor constant:16.0] setActive:YES];
    [[gridView.heightAnchor constraintEqualToConstant:130] setActive:YES];
    [[gridView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[gridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[gridView.bottomAnchor constraintEqualToAnchor:bookingRow.bottomAnchor constant:0] setActive:YES];
    return gridView;
}

- (BOOL) isOccupied:(MWZUIPlaceMock*)mock {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate now]];
    NSInteger hour = [components hour];
    NSInteger min = [components minute];
    double time = hour + min/60.0;
    
    for (NSDictionary* event in mock.calendarEvents) {
        double startTime = [event[@"startTime"] doubleValue];
        double endTime = [event[@"endTime"] doubleValue];
        if (startTime<time && endTime>time) {
            return YES;
        }
    }
    
    return NO;
}

- (MWZUIFullContentViewComponentRow*) getWebsiteRowForMock:(MWZUIPlaceMock*)mock {
    UILabel* websiteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    websiteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [websiteLabel setFont:[UIFont systemFontOfSize:14]];
    if (mock && mock.website) {
        [websiteLabel setText:_mock.website];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"network"] contentView:websiteLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [websiteLabel setText:@"Website not available"];
        UIFontDescriptor * fontD = [websiteLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        websiteLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        websiteLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"network"] contentView:websiteLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
    /*UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(toggleOpeningHours:)];*/
    
    
}

- (MWZUIFullContentViewComponentRow*) getPhoneRowForMock:(MWZUIPlaceMock*)mock {
    UILabel* phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    if (mock && mock.phoneNumber) {
        [phoneLabel setText:[_mock.phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@" "]];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"phone"] contentView:phoneLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [phoneLabel setText:@"Phone number not available"];
        UIFontDescriptor * fontD = [phoneLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        phoneLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        phoneLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"phone"] contentView:phoneLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (UIView*) addPhoneRowBelow:(UIView*) view {
    UIView* phoneRow = [[UIView alloc] initWithFrame:CGRectZero];
    phoneRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:phoneRow];
    [[phoneRow.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:0.0] setActive:YES];
    [[phoneRow.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0] setActive:YES];
    [[phoneRow.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0] setActive:YES];
    
    UIImageView* phoneImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    phoneImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [phoneImageView setImage:[[UIImage systemImageNamed:@"phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [phoneImageView setTintColor:_color];
    [phoneRow addSubview:phoneImageView];
    [[phoneImageView.leadingAnchor constraintEqualToAnchor:phoneRow.leadingAnchor constant:16] setActive:YES];
    [[phoneImageView.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:16.0] setActive:YES];
    [[phoneImageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[phoneImageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    [[phoneImageView.bottomAnchor constraintEqualToAnchor:phoneRow.bottomAnchor constant:0.0] setActive:YES];
    
    _phoneTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _phoneTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_phoneTextView setFont:[UIFont systemFontOfSize:14]];
    [_phoneTextView setText:[_mock.phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@" "]];
    
    [phoneRow addSubview:_phoneTextView];
    [[_phoneTextView.leadingAnchor constraintEqualToAnchor:phoneImageView.trailingAnchor constant:36] setActive:YES];
    [[_phoneTextView.trailingAnchor constraintEqualToAnchor:phoneRow.trailingAnchor] setActive:YES];
    [[_phoneTextView.centerYAnchor constraintEqualToAnchor:phoneImageView.centerYAnchor constant:0.0] setActive:YES];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePhoneTap:)];
    [phoneRow addGestureRecognizer:singleFingerTap];
    
    return phoneRow;
}

- (void) handlePhoneTap:(UITapGestureRecognizer*) recognier {
    NSURL *urlOption1 = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:_mock.phoneNumber]];
    NSURL *urlOption2 = [NSURL URLWithString:[@"tel://" stringByAppendingString:_mock.phoneNumber]];
    NSURL *targetURL = nil;
    if ([UIApplication.sharedApplication canOpenURL:urlOption1]) {
        targetURL = urlOption1;
    } else if ([UIApplication.sharedApplication canOpenURL:urlOption2]) {
        targetURL = urlOption2;
    }

    if (targetURL) {
        if (@available(iOS 10.0, *)) {
            [UIApplication.sharedApplication openURL:targetURL options:@{} completionHandler:nil];
        } else {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [UIApplication.sharedApplication openURL:targetURL];
    #pragma clang diagnostic pop
        }
    }
}

- (MWZUIFullContentViewComponentRow*) getOpeningHoursRowForMock:(MWZUIPlaceMock*)mock {
    _openingHoursView = [[MWZUIOpeningHoursView alloc] initWithFrame:CGRectZero];
    [_openingHoursView setOpeningHours:mock.openingHours];

    if (mock.openingHours.count > 0) {
        UITapGestureRecognizer *singleFingerTap =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(toggleOpeningHours:)];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"clock"] contentView:_openingHoursView color:_color tapGestureRecognizer:singleFingerTap type:MWZUIFullContentViewComponentRowOpeningHours infoAvailable:YES];
    }
    
    return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"clock"] contentView:_openingHoursView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowOpeningHours infoAvailable:NO];
}

- (UIView*) addOpeningHoursRowBelow:(UIView*) view {
    UIView* openingHoursRow = [[UIView alloc] initWithFrame:CGRectZero];
    openingHoursRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:openingHoursRow];
    [[openingHoursRow.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:0.0] setActive:YES];
    [[openingHoursRow.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0] setActive:YES];
    [[openingHoursRow.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0] setActive:YES];
    
    UIImageView* openingHoursImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    openingHoursImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [openingHoursImageView setImage:[[UIImage systemImageNamed:@"clock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [openingHoursImageView setTintColor:_color];
    [openingHoursRow addSubview:openingHoursImageView];
    [[openingHoursImageView.leadingAnchor constraintEqualToAnchor:openingHoursRow.leadingAnchor constant:16] setActive:YES];
    [[openingHoursImageView.topAnchor constraintEqualToAnchor:openingHoursRow.topAnchor constant:16.0] setActive:YES];
    [[openingHoursImageView.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[openingHoursImageView.widthAnchor constraintEqualToConstant:24] setActive:YES];
    
    _openingHoursView = [[MWZUIOpeningHoursView alloc] initWithFrame:CGRectZero];
    _openingHoursView.translatesAutoresizingMaskIntoConstraints = NO;
    [openingHoursRow addSubview:_openingHoursView];
    [[_openingHoursView.leadingAnchor constraintEqualToAnchor:openingHoursImageView.trailingAnchor constant:16] setActive:YES];
    [[_openingHoursView.trailingAnchor constraintEqualToAnchor:openingHoursRow.trailingAnchor] setActive:YES];
    [[_openingHoursView.topAnchor constraintEqualToAnchor:openingHoursRow.topAnchor constant:16.0] setActive:YES];
    [[_openingHoursView.bottomAnchor constraintEqualToAnchor:openingHoursRow.bottomAnchor constant:0] setActive:YES];
    [_openingHoursView setOpeningHours:@[]];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(toggleOpeningHours:)];
    [openingHoursRow addGestureRecognizer:singleFingerTap];
    
    return openingHoursRow;
}

- (void)toggleOpeningHours:(UITapGestureRecognizer *)recognizer
{
    [_openingHoursView toggleExpanded];
}

- (UIView*) addSeparatorBelow:(UIView*) view marginTop:(double) marginTop {
    UIView* separator = [[UIView alloc] initWithFrame:CGRectZero];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:separator];
    separator.backgroundColor = [UIColor lightGrayColor];
    [[separator.heightAnchor constraintEqualToConstant:0.5] setActive:YES];
    [[separator.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[separator.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[separator.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:marginTop] setActive:YES];
    [[separator.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    return separator;
}

@end