//
//  MWZUIFullContentView.m
//  BottomSheet
//
//  Created by Etienne on 28/09/2020.
//

#import "MWZUIFullContentView.h"
#import "MWZUIFullContentViewComponentButton.h"
#import "MWZUIOpeningHoursView.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIBookingView.h"
#import "MWZUIBottomSheet.h"
#import "MWZUIPagerView.h"
#import "MWZPlaceDetails.h"
#import <WebKit/WebKit.h>

@interface MWZUIFullContentView () <UIGestureRecognizerDelegate>

@property (nonatomic) UILabel* titleTextView;
@property (nonatomic) UILabel* subtitleTextView;
@property (nonatomic) UIStackView* headerButtonStackView;
@property (nonatomic) UIButton* directionButton;
@property (nonatomic) UIButton* callButton;
@property (nonatomic) UIButton* shareButton;
@property (nonatomic) UIButton* webSiteButton;
@property (nonatomic) MWZUIOpeningHoursView* openingHoursView;
@property (nonatomic) UILabel* phoneTextView;
@property (nonatomic) MWZUIPagerView* pagerView;

@end

@implementation MWZUIFullContentView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
    }
    return self;
}




-(void)setContentForPlaceDetails:(MWZPlaceDetails*)placeDetails
                 language:(NSString*)language
                  buttons:(NSArray<MWZUIFullContentViewComponentButton*>*)buttons
                     rows:(NSArray<MWZUIFullContentViewComponentRow*>*)rows {
    _placeDetails = placeDetails;
    
    _titleTextView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleTextView.font=[_titleTextView.font fontWithSize:21];
    _titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleTextView.text = [_placeDetails titleForLanguage:language];
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
    _subtitleTextView.text = [_placeDetails subtitleForLanguage:language];
    _subtitleTextView.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleTextView.numberOfLines = 0;
    [self addSubview:_subtitleTextView];
    [[_subtitleTextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0] setActive:YES];
    [[_subtitleTextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0] setActive:YES];
    [[_subtitleTextView.topAnchor constraintEqualToAnchor:_titleTextView.bottomAnchor constant:8.0] setActive:YES];
    [[_subtitleTextView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32] setActive:YES];
    
    UIScrollView* overviewScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    overviewScroll.showsVerticalScrollIndicator = NO;
    UIView* overview = [[UIView alloc] initWithFrame:CGRectZero];
    overview.translatesAutoresizingMaskIntoConstraints = NO;
    [overviewScroll addSubview:overview];
    [[overview.topAnchor constraintEqualToAnchor:overviewScroll.topAnchor] setActive:YES];
    [[overview.bottomAnchor constraintEqualToAnchor:overviewScroll.bottomAnchor] setActive:YES];
    [[overview.leadingAnchor constraintEqualToAnchor:overviewScroll.leadingAnchor] setActive:YES];
    [[overview.trailingAnchor constraintEqualToAnchor:overviewScroll.trailingAnchor] setActive:YES];
    [[overview.widthAnchor constraintEqualToAnchor:overviewScroll.widthAnchor] setActive:YES];
    //[[overviewScroll.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    _headerButtonStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _headerButtonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerButtonStackView.distribution = UIStackViewDistributionFillEqually;
    _headerButtonStackView.alignment = UIStackViewAlignmentLeading;
    _headerButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    [overview addSubview:_headerButtonStackView];
    [[_headerButtonStackView.topAnchor constraintEqualToAnchor:overview.topAnchor constant:0.0] setActive:YES];
    [[_headerButtonStackView.leadingAnchor constraintEqualToAnchor:overview.leadingAnchor constant:16.0] setActive:YES];
    [[_headerButtonStackView.trailingAnchor constraintLessThanOrEqualToAnchor:overview.trailingAnchor constant:-16.0] setActive:YES];
    [[_headerButtonStackView.heightAnchor constraintEqualToConstant:70] setActive:YES];
    
    for (MWZUIFullContentViewComponentButton* button in buttons) {
        [_headerButtonStackView addArrangedSubview:button];
    }
    
    if (buttons.count == 4) {
        [[_headerButtonStackView.widthAnchor constraintEqualToAnchor:overview.widthAnchor constant:-32] setActive:YES];
    }
    else {
        [[_headerButtonStackView.widthAnchor constraintLessThanOrEqualToAnchor:overview.widthAnchor constant:-32] setActive:YES];
    }
    
    UIView* lastView = [self addSeparatorBelow:_headerButtonStackView inView:overview marginTop:16];
    
    for (MWZUIFullContentViewComponentRow* row in rows) {
        lastView = [self addRow:row inView:overview below:lastView];
        if ([rows indexOfObject:row] < rows.count - 1) {
            lastView = [self addSeparatorBelow:lastView inView:overview marginTop:0];
        }
    }
    [[lastView.bottomAnchor constraintEqualToAnchor:overview.bottomAnchor constant:-16] setActive:YES];
    
    
    _pagerView = [[MWZUIPagerView alloc] initWithFrame:CGRectZero color:_color];
    _pagerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_pagerView addSlide:overviewScroll named:@"OVERVIEW"];
    if ([_placeDetails detailsForLanguage:language] && [_placeDetails detailsForLanguage:language].length > 0) {
        WKWebView* webview = [[WKWebView alloc] initWithFrame:CGRectZero];
        [webview loadHTMLString:[_placeDetails detailsForLanguage:language] baseURL:nil];
        [_pagerView addSlide:webview named:@"DETAILS"];
    }
    
    
    [self addSubview:_pagerView];
    [_pagerView.topAnchor constraintEqualToAnchor:_subtitleTextView.bottomAnchor constant:16].active = YES;
    [_pagerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_pagerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_pagerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [[_pagerView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    [_pagerView build];
}

- (NSMutableArray<MWZUIFullContentViewComponentButton*>*) buildHeaderButtonsForPlaceDetails:(MWZPlaceDetails*)placeDetails language:(NSString*)language {
    NSMutableArray<MWZUIFullContentViewComponentButton*>* buttons = [[NSMutableArray alloc] init];
    MWZUIFullContentViewComponentButton* directionButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"DIRECTIONS" image:[UIImage systemImageNamed:@"arrow.triangle.turn.up.right.diamond.fill"] color:_color outlined:NO];
    [directionButton addTarget:self action:@selector(directionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:directionButton];
    if (placeDetails.phone) {
        MWZUIFullContentViewComponentButton* phoneButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"CALL" image:[UIImage systemImageNamed:@"phone.fill"] color:_color outlined:YES];
        [phoneButton addTarget:self action:@selector(phoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:phoneButton];
    }
    if (placeDetails.website) {
        MWZUIFullContentViewComponentButton* websiteButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"WEBSITE" image:[UIImage systemImageNamed:@"network"] color:_color outlined:YES];
        [websiteButton addTarget:self action:@selector(websiteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:websiteButton];
    }
    if (NO) {//place.sharable) {
        MWZUIFullContentViewComponentButton* shareButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:@"SHARE" image:[UIImage systemImageNamed:@"square.and.arrow.up"] color:_color outlined:YES];
        [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:shareButton];
    }
    return buttons;
}

- (NSMutableArray<MWZUIFullContentViewComponentRow*>*) buildContentRowsForPlaceDetails:(MWZPlaceDetails*)placeDetails language:(NSString*)language {
    NSMutableArray<MWZUIFullContentViewComponentRow*>* rows = [[NSMutableArray alloc] init];
    NSMutableArray<MWZUIFullContentViewComponentRow*>* unfilledRow = [[NSMutableArray alloc] init];
    if (placeDetails.floor) {
        MWZUIFullContentViewComponentRow* row = [self getFloorRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getFloorRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    if (placeDetails.openingHours) {
        MWZUIFullContentViewComponentRow* row = [self getOpeningHoursRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getOpeningHoursRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    if (placeDetails.phone) {
        MWZUIFullContentViewComponentRow* row = [self getPhoneRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getPhoneRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    if (placeDetails.website) {
        MWZUIFullContentViewComponentRow* row = [self getWebsiteRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getWebsiteRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    if (placeDetails.capacity) {
        MWZUIFullContentViewComponentRow* row = [self getCapacityRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getCapacityRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    if (placeDetails.events) {//place.calendarEvents) {
        MWZUIFullContentViewComponentRow* row = [self getBookingRowForPlaceDetails:placeDetails];
        [rows addObject:row];
    }
    else {
        MWZUIFullContentViewComponentRow* row = [self getBookingRowForPlaceDetails:nil];
        [unfilledRow addObject:row];
    }
    [rows addObjectsFromArray:unfilledRow];
    return rows;
}

- (UIView*) addRow:(MWZUIFullContentViewComponentRow*)componentRow inView:(UIView*)inView below:(UIView*)view {
    [inView addSubview:componentRow];
    componentRow.translatesAutoresizingMaskIntoConstraints = NO;
    [[componentRow.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:0.0] setActive:YES];
    [[componentRow.leadingAnchor constraintEqualToAnchor:inView.leadingAnchor constant:0.0] setActive:YES];
    [[componentRow.trailingAnchor constraintEqualToAnchor:inView.trailingAnchor constant:0.0] setActive:YES];
    [[componentRow.widthAnchor constraintEqualToAnchor:inView.widthAnchor] setActive:YES];
    return componentRow;
}

- (MWZUIFullContentViewComponentRow*) getBookingRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    return [[MWZUIBookingView alloc] initWithFrame:CGRectZero placeDetails:placeDetails color:_color];
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
    BOOL isOccupied = [self isOccupied:_placeDetails];
    [bookingLabel setText:isOccupied?@"Currently occupied":@"Currently available"];
    
    [bookingRow addSubview:bookingLabel];
    [[bookingLabel.leadingAnchor constraintEqualToAnchor:bookingImageView.trailingAnchor constant:36] setActive:YES];
    [[bookingLabel.trailingAnchor constraintEqualToAnchor:bookingRow.trailingAnchor] setActive:YES];
    [[bookingLabel.centerYAnchor constraintEqualToAnchor:bookingImageView.centerYAnchor constant:0.0] setActive:YES];
    
    MWZUIBookingView* gridView = [[MWZUIBookingView alloc] initWithFrame:CGRectZero placeDetails:_placeDetails color:_color];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:gridView];
    [[gridView.topAnchor constraintEqualToAnchor:bookingImageView.bottomAnchor constant:16.0] setActive:YES];
    [[gridView.heightAnchor constraintEqualToConstant:130] setActive:YES];
    [[gridView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16] setActive:YES];
    [[gridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16] setActive:YES];
    [[gridView.bottomAnchor constraintEqualToAnchor:bookingRow.bottomAnchor constant:0] setActive:YES];
    return gridView;
}

- (BOOL) isOccupied:(MWZPlace*)place {
    /*NSCalendar *calendar = [NSCalendar currentCalendar];
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
    }*/
    
    return NO;
}

- (MWZUIFullContentViewComponentRow*) getWebsiteRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UILabel* websiteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    websiteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [websiteLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails && placeDetails.website) {
        NSString *searchedString = placeDetails.website;
        NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
        NSString *pattern = @"^(?:http[s]?://)?(?:www.)?([\\w.]+)";
        NSError  *error = nil;

        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
        [websiteLabel setText:[searchedString substringWithRange:[match rangeAtIndex:1]]];
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

- (MWZUIFullContentViewComponentRow*) getFloorRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UILabel* floorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    floorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [floorLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails) {
        if (placeDetails.floor) {
            [floorLabel setText:[NSString stringWithFormat:@"%@", placeDetails.floor]];
        }
        else {
            [floorLabel setText:@"Outdoor"];
        }
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"alt"] contentView:floorLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [floorLabel setText:@"Capacity not available"];
        UIFontDescriptor * fontD = [floorLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        floorLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        floorLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"alt"] contentView:floorLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (MWZUIFullContentViewComponentRow*) getCapacityRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UILabel* capacityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    capacityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [capacityLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails && placeDetails.capacity) {
        [capacityLabel setText:[NSString stringWithFormat:@"%@", placeDetails.capacity]];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"person.3"] contentView:capacityLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [capacityLabel setText:@"Capacity not available"];
        UIFontDescriptor * fontD = [capacityLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        capacityLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        capacityLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"person.3"] contentView:capacityLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (MWZUIFullContentViewComponentRow*) getPhoneRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UILabel* phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails && placeDetails.phone) {
        [phoneLabel setText:[placeDetails.phone stringByReplacingOccurrencesOfString:@"." withString:@" "]];
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

/*- (void) handlePhoneTap:(UITapGestureRecognizer*) recognier {
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
}*/

- (MWZUIFullContentViewComponentRow*) getOpeningHoursRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    _openingHoursView = [[MWZUIOpeningHoursView alloc] initWithFrame:CGRectZero];
    [_openingHoursView setOpeningHours:placeDetails.openingHours];

    if (placeDetails.openingHours.count > 0) {
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

- (UIView*) addSeparatorBelow:(UIView*) view inView:(UIView*)inView marginTop:(double) marginTop {
    UIView* separator = [[UIView alloc] initWithFrame:CGRectZero];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [inView addSubview:separator];
    separator.backgroundColor = [UIColor lightGrayColor];
    [[separator.heightAnchor constraintEqualToConstant:0.5] setActive:YES];
    [[separator.leadingAnchor constraintEqualToAnchor:inView.leadingAnchor] setActive:YES];
    [[separator.trailingAnchor constraintEqualToAnchor:inView.trailingAnchor] setActive:YES];
    [[separator.topAnchor constraintEqualToAnchor:view.bottomAnchor constant:marginTop] setActive:YES];
    [[separator.widthAnchor constraintEqualToAnchor:inView.widthAnchor] setActive:YES];
    return separator;
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
