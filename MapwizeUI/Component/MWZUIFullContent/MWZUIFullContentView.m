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
#import <MapwizeSDK/MapwizeSDK.h>
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
    [[_titleTextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8.0] setActive:YES];
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
    
    UIView* lastView;
    
    if ([buttons count] <= 4) {
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
        lastView = [self addSeparatorBelow:_headerButtonStackView inView:overview marginTop:16];
    }
    
    else {
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        [overview addSubview:scrollView];
        [[scrollView.topAnchor constraintEqualToAnchor:overview.topAnchor constant:0.0] setActive:YES];
        [[scrollView.leadingAnchor constraintEqualToAnchor:overview.leadingAnchor constant:0.0] setActive:YES];
        [[scrollView.trailingAnchor constraintEqualToAnchor:overview.trailingAnchor constant:0.0] setActive:YES];
        [[scrollView.heightAnchor constraintEqualToConstant:96] setActive:YES];
        
        UIView* lastAnchorButton = nil;
        for (MWZUIFullContentViewComponentButton* button in buttons) {
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [scrollView addSubview:button];
            if (lastAnchorButton) {
                [[button.leadingAnchor constraintEqualToAnchor:lastAnchorButton.trailingAnchor constant:8.0] setActive:YES];
            }
            else {
                [[button.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor constant:8.0] setActive:YES];
            }
            [[button.widthAnchor constraintEqualToConstant:100] setActive:YES];
            [[button.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:8.0] setActive:YES];
            [[button.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:-8.0] setActive:YES];
            lastAnchorButton = button;
        }
        [[lastAnchorButton.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor] setActive:YES];
        
        lastView = [self addSeparatorBelow:scrollView inView:overview marginTop:16];
    }
    
    
    
    
    for (MWZUIFullContentViewComponentRow* row in rows) {
        lastView = [self addRow:row inView:overview below:lastView];
        if ([rows indexOfObject:row] < rows.count - 1) {
            lastView = [self addSeparatorBelow:lastView inView:overview marginTop:0];
        }
    }
    [[lastView.bottomAnchor constraintEqualToAnchor:overview.bottomAnchor constant:-16] setActive:YES];
    
    
    _pagerView = [[MWZUIPagerView alloc] initWithFrame:CGRectZero color:_color];
    _pagerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_pagerView addSlide:overviewScroll named:[NSLocalizedString(@"Overview", @"") uppercaseString]];
    if ([_placeDetails detailsForLanguage:language] && [_placeDetails detailsForLanguage:language].length > 0) {
        WKWebView* webview = [[WKWebView alloc] initWithFrame:CGRectZero];
        [webview loadHTMLString:[_placeDetails detailsForLanguage:language] baseURL:nil];
        [_pagerView addSlide:webview named:[NSLocalizedString(@"Details", @"") uppercaseString]];
    }
    
    
    [self addSubview:_pagerView];
    [_pagerView.topAnchor constraintEqualToAnchor:_subtitleTextView.bottomAnchor constant:16].active = YES;
    [_pagerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_pagerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_pagerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [[_pagerView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
    [_pagerView build];
}

- (NSMutableArray<MWZUIFullContentViewComponentButton*>*) buildHeaderButtonsForPlaceDetails:(MWZPlaceDetails*)placeDetails
                                                                             showInfoButton:(BOOL)shouldShowInformationButton
                                                                                   language:(NSString*)language {
    NSMutableArray<MWZUIFullContentViewComponentButton*>* buttons = [[NSMutableArray alloc] init];
    MWZUIFullContentViewComponentButton* directionButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:[NSLocalizedString(@"Direction", @"") uppercaseString] image:[UIImage imageNamed:@"direction" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] color:_color outlined:NO];
    [directionButton addTarget:self action:@selector(directionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:directionButton];
    if (shouldShowInformationButton) {
        UIImage* image = [UIImage imageNamed:@"info" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        MWZUIFullContentViewComponentButton* informationButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:[NSLocalizedString(@"Information", @"") uppercaseString] image:image color:_color outlined:YES];
        [informationButton addTarget:self action:@selector(informationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:informationButton];
    }
    if (placeDetails.phone) {
        UIImage* image = [UIImage imageNamed:@"phone" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        MWZUIFullContentViewComponentButton* phoneButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:[NSLocalizedString(@"Call", @"") uppercaseString] image:image color:_color outlined:YES];
        [phoneButton addTarget:self action:@selector(phoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:phoneButton];
    }
    if (placeDetails.website) {
        UIImage* image = [UIImage imageNamed:@"globe" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        MWZUIFullContentViewComponentButton* websiteButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:[NSLocalizedString(@"Website", @"") uppercaseString] image:image color:_color outlined:YES];
        [websiteButton addTarget:self action:@selector(websiteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:websiteButton];
    }
    if (placeDetails.shareLink) {
        UIImage* image = [UIImage imageNamed:@"share" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        MWZUIFullContentViewComponentButton* shareButton = [[MWZUIFullContentViewComponentButton alloc] initWithTitle:[NSLocalizedString(@"Share", @"") uppercaseString] image:image color:_color outlined:YES];
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

- (MWZUIFullContentViewComponentRow*) getWebsiteRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UIImage* image = [UIImage imageNamed:@"globe" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
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
        UITapGestureRecognizer *singleFingerTap =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(websiteButtonAction:)];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:websiteLabel color:_color tapGestureRecognizer:singleFingerTap type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [websiteLabel setText:NSLocalizedString(@"Website not available", @"")];
        UIFontDescriptor * fontD = [websiteLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        websiteLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        websiteLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:websiteLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
    
    
}

- (MWZUIFullContentViewComponentRow*) getFloorRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UIImage* image = [UIImage imageNamed:@"floor" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UILabel* floorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    floorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [floorLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails) {
        if (placeDetails.floor) {
            if (placeDetails.floor[@"number"]) {
                [floorLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Floor %@", @""), placeDetails.floor[@"number"]]];
            }
            else {
                [floorLabel setText:NSLocalizedString(@"Outdoor", @"")];
            }
        }
        else {
            [floorLabel setText:NSLocalizedString(@"Outdoor", @"")];
        }
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:floorLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [floorLabel setText:NSLocalizedString(@"Floor not available",@"")];
        UIFontDescriptor * fontD = [floorLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        floorLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        floorLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:floorLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (MWZUIFullContentViewComponentRow*) getCapacityRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UILabel* capacityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIImage* capacityImage = [UIImage imageNamed:@"group" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    capacityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [capacityLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails && placeDetails.capacity) {
        [capacityLabel setText:[NSString stringWithFormat:@"%@", placeDetails.capacity]];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:capacityImage contentView:capacityLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [capacityLabel setText:NSLocalizedString(@"Capacity not available",@"")];
        UIFontDescriptor * fontD = [capacityLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        capacityLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        capacityLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:capacityImage contentView:capacityLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (MWZUIFullContentViewComponentRow*) getPhoneRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UIImage* image = [UIImage imageNamed:@"phoneOutline" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UILabel* phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    if (placeDetails && placeDetails.phone) {
        [phoneLabel setText:[placeDetails.phone stringByReplacingOccurrencesOfString:@"." withString:@" "]];
        UITapGestureRecognizer *singleFingerTap =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(phoneButtonAction:)];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:phoneLabel color:_color tapGestureRecognizer:singleFingerTap type:MWZUIFullContentViewComponentRowWebsite infoAvailable:YES];
    }
    else {
        [phoneLabel setText:NSLocalizedString(@"Phone number not available", @"")];
        UIFontDescriptor * fontD = [phoneLabel.font.fontDescriptor
                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        phoneLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        phoneLabel.textColor = [UIColor darkGrayColor];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:phoneLabel color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowWebsite infoAvailable:NO];
    }
}

- (MWZUIFullContentViewComponentRow*) getOpeningHoursRowForPlaceDetails:(MWZPlaceDetails*)placeDetails {
    UIImage* image = [UIImage imageNamed:@"clock" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    _openingHoursView = [[MWZUIOpeningHoursView alloc] initWithFrame:CGRectZero];
    [_openingHoursView setOpeningHours:placeDetails.openingHours timezoneCode:placeDetails.timezone];

    if (placeDetails.openingHours.count > 0) {
        UITapGestureRecognizer *singleFingerTap =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(toggleOpeningHours:)];
        return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:_openingHoursView color:_color tapGestureRecognizer:singleFingerTap type:MWZUIFullContentViewComponentRowOpeningHours infoAvailable:YES];
    }
    
    return [[MWZUIFullContentViewComponentRow alloc] initWithImage:image contentView:_openingHoursView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowOpeningHours infoAvailable:NO];
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
    [[separator.heightAnchor constraintEqualToConstant:1] setActive:YES];
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

- (void) informationButtonAction:(UIButton*)button {
    [_delegate didTapOnInfoButton];
}


@end
