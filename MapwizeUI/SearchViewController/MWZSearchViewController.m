#import "MWZSearchViewController.h"
#import "MWZSearchQueryBarDelegate.h"
#import "MWZUIConstants.h"

@interface MWZSearchViewController () <MWZSearchQueryBarDelegate>

@end

@implementation MWZSearchViewController

- (void) setSearchOptions:(MWZSearchViewControllerOptions *)searchOptions {
    _searchOptions = searchOptions;
    [self loadInitialResults];
}

- (void) loadInitialResults {
    [self loadDefaultVenueResults];
}
- (void) loadDefaultVenueResults {
    MWZApiFilter* filter = [[MWZApiFilter alloc] init];
    [[MWZMapwizeApiFactory getApi] getVenuesWithFilter:filter success:^(NSArray<MWZVenue *> * _Nonnull venues) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultList swapResults:venues];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Search venue failed %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize {
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.backgroundView];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.backgroundView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0.0] setActive:YES];
    
    self.searchQueryBar = [[MWZSearchQueryBar alloc] initWithFrame:CGRectZero];
    self.searchQueryBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchQueryBar.delegate = self;
    [self.view addSubview:self.searchQueryBar];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.view.safeAreaInsets.right - MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.view.safeAreaInsets.left + MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
    }
    
    self.resultContainerView = [[UIView alloc] init];
    self.resultContainerView.clipsToBounds = YES;
    self.resultContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultContainerView];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.view.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.view.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-MWZDefaultPadding] setActive:YES];
        _resultContainerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.resultContainerView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:0.0f];
        _resultContainerViewHeightConstraint.priority = 999;
        [_resultContainerViewHeightConstraint setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:MWZDefaultPadding] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-MWZDefaultPadding] setActive:YES];
        _resultContainerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.resultContainerView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:0.0f];
        _resultContainerViewHeightConstraint.priority = 999;
        [_resultContainerViewHeightConstraint setActive:YES];
    }
    
    self.resultList = [[MWZComponentResultList alloc] init];
    self.resultList.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resultContainerView addSubview:self.resultList];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.resultList
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.resultContainerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f
                                                                constant:8.0f];
        top.priority = 998;
        [top setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
    
    } else {
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.resultList
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.resultContainerView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:0.0f] setActive:YES];
    }
    
    [self.searchQueryBar.searchTextField becomeFirstResponder];
}

- (void) searchQueryDidChange:(NSString*) query {
    MWZSearchParams* searchParams = [[MWZSearchParams alloc] init];
    searchParams.objectClass = @[@"venue"];
    searchParams.query = query;
    [[MWZMapwizeApiFactory getApi] searchWithSearchParams:searchParams success:^(NSArray<id<MWZObject>> * _Nonnull searchResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultList swapResults:searchResponse];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Search venue failed %@", error);
    }];
}

- (void)didTapOnBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
