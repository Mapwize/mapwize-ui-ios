#import "MWZUIIssuesReportingViewController.h"
#import "MWZUIFullContentViewComponentRow.h"
#import "MWZUIIssueTypeView.h"
#import "MWZUITwoLinesRow.h"
#import "MWZUILabelRow.h"

@interface MWZUIIssuesReportingViewController () <UITextViewDelegate, MWZUIIssueTypeViewDelegate>

@property (nonatomic) UILabel* targetedContentSummary;
@property (nonatomic) UITextField* summaryTextField;
@property (nonatomic) UITextView* descriptionTextView;
@property (nonatomic) UILabel* pickedIssueType;
@property (nonatomic) UIButton* sendIssueButton;
@property (nonatomic) UIButton* validateIssueTypeButton;

@property (nonatomic) UILabel* typeDescription;
@property (nonatomic) UILabel* subjectDescription;
@property (nonatomic) UILabel* descriptionDescription;
@property (nonatomic) UITextField* userContentView;
@property (nonatomic) UITextView* detailsContentView;
@property (nonatomic) id<MWZMapwizeApi> api;

@property (nonatomic) MWZIssueType* selectedIssueType;
@property (nonatomic) MWZVenue* venue;
@property (nonatomic) MWZPlaceDetails* placeDetails;
@property (nonatomic) MWZUserInfo* userInfo;
@property (nonatomic) NSArray<MWZIssueType*>* issueTypes;
@property (nonatomic) UIColor* color;
@property (nonatomic) NSString* language;

@property (nonatomic) MWZUITwoLinesRow* emailRow;
@property (nonatomic) MWZUIIssueTypeView* issueTypeRow;
@property (nonatomic) MWZUITwoLinesRow* summaryRow;
@property (nonatomic) MWZUITwoLinesRow* descriptionRow;

@property (nonatomic) UIScrollView* scrollView;

@end

@implementation MWZUIIssuesReportingViewController

- (instancetype) initWithVenue:(MWZVenue*)venue
                  placeDetails:(MWZPlaceDetails*)placeDetails
                      userInfo:(MWZUserInfo*)userInfo
                      language:(NSString*)language
                         color:(UIColor*)color
                           api:(id<MWZMapwizeApi>)api{
    self = [super init];
    _venue = venue;
    _placeDetails = placeDetails;
    _userInfo = userInfo;
    _issueTypes = placeDetails.issueTypes;
    _color = color;
    _language = language;
    _api = api;
    [self registerForKeyboardNotifications];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void) initView {
    _targetedContentSummary = [[UILabel alloc] initWithFrame:CGRectZero];
    _targetedContentSummary.text = NSLocalizedString(@"Report an issue", @"");
    _targetedContentSummary.font = [UIFont systemFontOfSize:28];
    _targetedContentSummary.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_targetedContentSummary];
    [[_targetedContentSummary.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0] setActive:YES];
    [[_targetedContentSummary.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16.0] setActive:YES];
    [[_targetedContentSummary.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    
    UIButton* sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [sendButton addTarget:self
                   action:@selector(sendIssue)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    
    UIImage* sendImage = [[UIImage imageNamed:@"send" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [sendButton.imageView setTintColor:_color];
    [sendButton setImage:sendImage forState:UIControlStateNormal];
    [[sendButton.heightAnchor constraintEqualToConstant:24] setActive:YES];
    [[sendButton.widthAnchor constraintEqualToConstant:24] setActive:YES];
    [[sendButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16] setActive:YES];
    [[sendButton.centerYAnchor constraintEqualToAnchor:_targetedContentSummary.centerYAnchor constant:0] setActive:YES];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    [[_scrollView.topAnchor constraintEqualToAnchor:_targetedContentSummary.bottomAnchor] setActive:YES];
    [[_scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[_scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[_scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    
    UILabel* venueContentView = [[UILabel alloc] initWithFrame:CGRectZero];
    venueContentView.text = [_venue titleForLanguage:_language];
    [venueContentView setFont:[UIFont systemFontOfSize:14]];
    MWZUILabelRow* venueRow = [[MWZUILabelRow alloc] initWithImage:[UIImage imageNamed:@"venue" inBundle:bundle compatibleWithTraitCollection:nil] label:[_venue titleForLanguage:_language] color:_color];
    venueRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:venueRow];
    [[venueRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[venueRow.topAnchor constraintEqualToAnchor:_scrollView.topAnchor constant:8.0] setActive:YES];
    [[venueRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    
    UIView* lastView = [self addSeparatorBelow:venueRow inView:_scrollView marginTop:0.0];
    UILabel* placeContentView = [[UILabel alloc] initWithFrame:CGRectZero];
    placeContentView.text = [_placeDetails titleForLanguage:_language];
    [placeContentView setFont:[UIFont systemFontOfSize:14]];
    MWZUILabelRow* placeRow = [[MWZUILabelRow alloc] initWithImage:[UIImage imageNamed:@"place" inBundle:bundle compatibleWithTraitCollection:nil] label:[_placeDetails titleForLanguage:_language] color:_color];
    placeRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:placeRow];
    [[placeRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[placeRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[placeRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:placeRow inView:_scrollView marginTop:0.0];
    
    _userContentView = [[UITextField alloc] initWithFrame:CGRectZero];
    _userContentView.placeholder = NSLocalizedString(@"Email", @"");
    if (_userInfo) {
        _userContentView.text = _userInfo.email;
    }
    [_userContentView setFont:[UIFont systemFontOfSize:14]];
    _emailRow = [[MWZUITwoLinesRow alloc] initWithImage:[UIImage imageNamed:@"people" inBundle:bundle compatibleWithTraitCollection:nil] label:NSLocalizedString(@"Email", @"") view:_userContentView color:_color];
    _emailRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_emailRow];
    [[_emailRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[_emailRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[_emailRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:_emailRow inView:_scrollView marginTop:0.0];
    
    _issueTypeRow = [[MWZUIIssueTypeView alloc] initWithFrame:CGRectZero issueTypes:_issueTypes color:_color language:_language];
    _issueTypeRow.delegate = self;
    _issueTypeRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_issueTypeRow];
    [[_issueTypeRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[_issueTypeRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[_issueTypeRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:_issueTypeRow inView:_scrollView marginTop:0.0];
    
    _summaryTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _summaryTextField.placeholder = NSLocalizedString(@"Summary", @"");
    [_summaryTextField setFont:[UIFont systemFontOfSize:14]];
    _summaryRow = [[MWZUITwoLinesRow alloc] initWithImage:[UIImage imageNamed:@"object" inBundle:bundle compatibleWithTraitCollection:nil] label:NSLocalizedString(@"Summary", @"") view:_summaryTextField color:_color];
    _summaryRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_summaryRow];
    [[_summaryRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[_summaryRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[_summaryRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    
    lastView = [self addSeparatorBelow:_summaryRow inView:_scrollView marginTop:0.0];
    
    _detailsContentView = [[UITextView alloc] initWithFrame:CGRectZero];
    _detailsContentView.textContainer.lineFragmentPadding = 0;
    _detailsContentView.textContainerInset = UIEdgeInsetsMake(4, 0, 4, 0);
    _detailsContentView.text = NSLocalizedString(@"Description", @"");
    _detailsContentView.textColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    _detailsContentView.font = _summaryTextField.font;
    _detailsContentView.delegate = self;
    [[_detailsContentView.heightAnchor constraintEqualToConstant:100] setActive:YES];
    [_detailsContentView setFont:_summaryTextField.font];
    _descriptionRow = [[MWZUITwoLinesRow alloc] initWithImage:[UIImage imageNamed:@"description" inBundle:bundle compatibleWithTraitCollection:nil] label:NSLocalizedString(@"Description", @"") view:_detailsContentView color:_color];
    _descriptionRow.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_descriptionRow];
    [[_descriptionRow.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:8.0] setActive:YES];
    [[_descriptionRow.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:0.0] setActive:YES];
    [[_descriptionRow.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-8.0] setActive:YES];
    [[_descriptionRow.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor constant:0.0] setActive:YES];
    
    
    [_api getUserInfoWithSuccess:^(MWZUserInfo * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userContentView.text = userInfo.email;
            self.userInfo = userInfo;
        });
        } failure:^(NSError * _Nonnull error) {
            
        }];
}

- (void) sendIssue {
    NSString* description = [_detailsContentView.text isEqualToString:NSLocalizedString(@"Description", @"")] ? @"" : _detailsContentView.text;
    [_api createIssueWithVenueId:_venue.identifier ownerId:_venue.owner placeId:_placeDetails.identifier reporterEmail:_userContentView.text summary:_summaryTextField.text description:description issueTypeId:_selectedIssueType.identifier success:^(MWZIssue * _Nonnull issue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* message = NSLocalizedString(@"Your issue has been reported!", @"");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User action"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
        } failure:^(NSError * _Nonnull error, NSDictionary* _Nonnull messages) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self highlightMissingFields:messages];
            });
        }];
}

- (void) highlightMissingFields:(NSDictionary*)messages {
    NSDictionary* errors = messages[@"errors"];
    if (errors[@"summary"] && ![errors[@"summary"] isEqual: NSNull.null]) {
        [_summaryRow setErrorMessage:NSLocalizedString(@"This field is required", @"")];
    }
    if (errors[@"description"] && ![errors[@"description"] isEqual: NSNull.null]) {
        [_descriptionRow setErrorMessage:NSLocalizedString(@"This field is required", @"")];
    }
    if (errors[@"issueTypeId"] && ![errors[@"issueTypeId"] isEqual: NSNull.null]) {
        [_issueTypeRow setErrorMessage:NSLocalizedString(@"This field is required", @"")];
    }
}

#pragma UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:NSLocalizedString(@"Description", @"")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Description", @"");
        textView.textColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
        textView.font = _summaryTextField.font;
    }
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

- (void)didSelectIssueType:(MWZIssueType *)issueType {
    _selectedIssueType = issueType;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];

   [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _descriptionTextView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_descriptionTextView.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

@end
