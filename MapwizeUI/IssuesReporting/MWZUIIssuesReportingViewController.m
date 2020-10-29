#import "MWZUIIssuesReportingViewController.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIIssueTypeView.h"

@interface MWZUIIssuesReportingViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>

@property (nonatomic) UILabel* targetedContentSummary;
@property (nonatomic) UITextField* summaryTextField;
@property (nonatomic) UITextView* descriptionTextView;
@property (nonatomic) UILabel* pickedIssueType;
@property (nonatomic) UIPickerView* issueTypesPicker;
@property (nonatomic) UIButton* sendIssueButton;
@property (nonatomic) UIButton* validateIssueTypeButton;

@property (nonatomic) UILabel* typeDescription;
@property (nonatomic) UILabel* subjectDescription;
@property (nonatomic) UILabel* descriptionDescription;

@property (nonatomic) NSString* selectedIssueType;
@property (nonatomic) MWZVenue* venue;
@property (nonatomic) MWZPlace* place;
@property (nonatomic) MWZUserInfo* userInfo;
@property (nonatomic) NSArray<NSString*>* issueTypes;
@property (nonatomic) UIColor* color;

@end

@implementation MWZUIIssuesReportingViewController

- (instancetype) initWithVenue:(MWZVenue*)venue place:(MWZPlace*)place userInfo:(MWZUserInfo*)userInfo color:(UIColor*)color {
    self = [super init];
    _venue = venue;
    _place = place;
    _userInfo = userInfo;
    _issueTypes = @[@"Place cassée", @"Plan moche", @"Trait pas droit", @"Android c'est nul"];
    _color = color;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void) initView {
    _targetedContentSummary = [[UILabel alloc] initWithFrame:CGRectZero];
    _targetedContentSummary.text = @"Report an issue";
    _targetedContentSummary.font = [UIFont systemFontOfSize:28];
    _targetedContentSummary.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_targetedContentSummary];
    [[_targetedContentSummary.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0] setActive:YES];
    [[_targetedContentSummary.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16.0] setActive:YES];
    [[_targetedContentSummary.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    
    UIButton* sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sendButton];
    
    UIImage* sendImage = [[UIImage systemImageNamed:@"paperplane.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [sendButton.imageView setTintColor:_color];
    [sendButton setImage:sendImage forState:UIControlStateNormal];
    [[sendButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16] setActive:YES];
    [[sendButton.centerYAnchor constraintEqualToAnchor:_targetedContentSummary.centerYAnchor constant:0] setActive:YES];
    
    UILabel* venueContentView = [[UILabel alloc] initWithFrame:CGRectZero];
    venueContentView.text = [_venue titleForLanguage:@"en"];
    [venueContentView setFont:[UIFont systemFontOfSize:14]];
    MWZUIFullContentViewComponentRow* venueRow = [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"building.fill"] contentView:venueContentView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowCustom infoAvailable:YES];
    venueRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:venueRow];
    [[venueRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
    [[venueRow.topAnchor constraintEqualToAnchor:_targetedContentSummary.bottomAnchor constant:8.0] setActive:YES];
    [[venueRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    
    UIView* lastView = [self addSeparatorBelow:venueRow inView:self.view marginTop:0.0];
    if (_place) {
        UILabel* placeContentView = [[UILabel alloc] initWithFrame:CGRectZero];
        placeContentView.text = [_place titleForLanguage:@"en"];
        [placeContentView setFont:[UIFont systemFontOfSize:14]];
        MWZUIFullContentViewComponentRow* placeRow = [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"mappin.circle.fill"] contentView:placeContentView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowCustom infoAvailable:YES];
        placeRow.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:placeRow];
        [[placeRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
        [[placeRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
        [[placeRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
        
        lastView = [self addSeparatorBelow:placeRow inView:self.view marginTop:0.0];
    }
    
    if (_userInfo) {
        UILabel* userContentView = [[UILabel alloc] initWithFrame:CGRectZero];
        userContentView.text = _userInfo.displayName;
        [userContentView setFont:[UIFont systemFontOfSize:14]];
        MWZUIFullContentViewComponentRow* userRow = [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"person.fill"] contentView:userContentView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowCustom infoAvailable:YES];
        userRow.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:userRow];
        [[userRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
        [[userRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
        [[userRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
        
        lastView = [self addSeparatorBelow:userRow inView:self.view marginTop:0.0];
    }
    
    MWZUIIssueTypeView* issueTypesRow = [[MWZUIIssueTypeView alloc] initWithFrame:CGRectZero issueTypes:_issueTypes color:_color];
    issueTypesRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:issueTypesRow];
    [[issueTypesRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
    [[issueTypesRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[issueTypesRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:issueTypesRow inView:self.view marginTop:0.0];
    
    UITextField* summaryContentView = [[UITextField alloc] initWithFrame:CGRectZero];
    summaryContentView.placeholder = @"Summary";
    [summaryContentView setFont:[UIFont systemFontOfSize:14]];
    MWZUIFullContentViewComponentRow* summaryRow = [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"] contentView:summaryContentView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowCustom infoAvailable:YES];
    summaryRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:summaryRow];
    [[summaryRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
    [[summaryRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[summaryRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:summaryRow inView:self.view marginTop:0.0];
    
    UITextView* detailsContentView = [[UITextView alloc] initWithFrame:CGRectZero];
    detailsContentView.textContainer.lineFragmentPadding = 0;
    detailsContentView.textContainerInset = UIEdgeInsetsMake(4, 0, 4, 0);
    detailsContentView.text = @"Description";
    detailsContentView.textColor = [UIColor placeholderTextColor];
    detailsContentView.font = summaryContentView.font;
    detailsContentView.delegate = self;
    [[detailsContentView.heightAnchor constraintEqualToConstant:100] setActive:YES];
    [detailsContentView setFont:summaryContentView.font];
    MWZUIFullContentViewComponentRow* detailsRow = [[MWZUIFullContentViewComponentRow alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"] contentView:detailsContentView color:_color tapGestureRecognizer:nil type:MWZUIFullContentViewComponentRowCustom infoAvailable:YES];
    detailsRow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detailsRow];
    [[detailsRow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8.0] setActive:YES];
    [[detailsRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[detailsRow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
}

- (void) validateIssueTypeButtonAction:(UIButton*)button {
    _selectedIssueType = _issueTypes[[_issueTypesPicker selectedRowInComponent:0]];
    _pickedIssueType.textColor = [UIColor blackColor];
    _pickedIssueType.text = _selectedIssueType;
    _pickedIssueType.hidden = NO;
    _summaryTextField.hidden = NO;
    _descriptionTextView.hidden = NO;
    _sendIssueButton.hidden = NO;
    _issueTypesPicker.hidden = YES;
    _validateIssueTypeButton.hidden = YES;
    _subjectDescription.hidden = NO;
    _descriptionDescription.hidden = NO;
}

- (void) showIssueTypePicker:(UITapGestureRecognizer *)recognizer {
    _pickedIssueType.hidden = YES;
    _summaryTextField.hidden = YES;
    _descriptionTextView.hidden = YES;
    _sendIssueButton.hidden = YES;
    _issueTypesPicker.hidden = NO;
    _validateIssueTypeButton.hidden = NO;
    _subjectDescription.hidden = YES;
    _descriptionDescription.hidden = YES;
}

#pragma UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Description";
        textView.textColor = [UIColor placeholderTextColor];
        textView.font = _pickedIssueType.font;
    }
}

#pragma UIPickerViewDelegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _issueTypes.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _issueTypes[row];
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

@end
