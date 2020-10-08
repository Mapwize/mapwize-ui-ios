//
//  MWZUIOpeningHoursView.m
//  BottomSheet
//
//  Created by Etienne on 30/09/2020.
//

#import "MWZUIOpeningHoursView.h"
#import "MWZUIOpeningHoursTableViewCell.h"
@interface MWZUIOpeningHoursView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSLayoutConstraint* tableViewHeightConstraint;

@end

@implementation MWZUIOpeningHoursView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _expanded = NO;
        [self initViews];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void) setOpeningHours:(NSArray *)openingHours {
    _openingHours = openingHours;
    [_tableView reloadData];
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    [_tableView reloadData];
}

- (void) toggleExpanded {
    [self setExpanded:!_expanded];
}

- (void) initViews {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    [_tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self addSubview:_tableView];
    [[_tableView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    _tableViewHeightConstraint = [_tableView.heightAnchor constraintEqualToConstant:0.0];
    [_tableViewHeightConstraint setActive:YES];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
    {
        _tableViewHeightConstraint.constant = _tableView.contentSize.height;
    }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MWZUIOpeningHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"openingCell"];
    if (cell == nil) {
        cell = [[MWZUIOpeningHoursTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"openingCell"];
    }
    if (_expanded) {
        cell.titleLabel.text = [NSString stringWithFormat:@"Day %ld opening", (long)indexPath.row];
    }
    else {
        if (_openingHours.count > 0) {
            cell.titleLabel.text = @"Today opening";
            cell.titleLabel.font = [cell.titleLabel.font fontWithSize:14];
        }
        else {
            cell.titleLabel.text = @"Opening hours not available";
            UIFontDescriptor * fontD = [cell.titleLabel.font.fontDescriptor
                        fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
            cell.titleLabel.font = [UIFont fontWithDescriptor:fontD size:14];
            cell.titleLabel.textColor = [UIColor darkGrayColor];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_expanded) {
        return 7;
    }
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self setExpanded:!_expanded];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}

@end
