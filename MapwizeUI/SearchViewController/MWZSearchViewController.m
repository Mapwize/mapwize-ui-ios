#import "MWZSearchViewController.h"
#import "MWZSearchQueryBarDelegate.h"

@interface MWZSearchViewController () <MWZSearchQueryBarDelegate>

@end

@implementation MWZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize {
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.backgroundView setBackgroundColor:[UIColor lightGrayColor]];
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
                                       constant:-self.view.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.view.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:-self.view.safeAreaInsets.right - 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant: self.view.safeAreaInsets.left + 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.view.safeAreaLayoutGuide
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        _tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
        _tableViewHeightConstraint.priority = 999;
        [_tableViewHeightConstraint setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0f
                                       constant:- 8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.searchQueryBar
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:8.0f] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:self.tableView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                       constant:-8.0f] setActive:YES];
        _tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
        _tableViewHeightConstraint.priority = 999;
        [_tableViewHeightConstraint setActive:YES];
    }
    
    [self.searchQueryBar.searchTextField becomeFirstResponder];
}



- (void)didTapOnBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
