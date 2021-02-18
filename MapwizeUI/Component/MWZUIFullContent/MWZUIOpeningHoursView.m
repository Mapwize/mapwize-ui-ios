//
//  MWZUIOpeningHoursView.m
//  BottomSheet
//
//  Created by Etienne on 30/09/2020.
//

#import "MWZUIOpeningHoursView.h"
#import "MWZUIOpeningHoursTableViewCell.h"
#import "MWZUIOpeningHoursUtils.h"
#import "MWZUIOpeningInterval.h"
#import "MWZUIOpeningHoursTodayTableViewCell.h"

@interface MWZUIOpeningHoursView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSString* timezoneCode;
@property (nonatomic) NSLayoutConstraint* tableViewHeightConstraint;
@property (nonatomic) NSArray<NSDictionary*>* sortedIntervals;

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

- (void) setOpeningHours:(NSArray *)openingHours timezoneCode:(NSString*) timezoneCode {
    _timezoneCode = timezoneCode;
    _openingHours = openingHours;
    _sortedIntervals = [MWZUIOpeningHoursUtils getOpeningStrings:openingHours];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _tableViewHeightConstraint.constant = _tableView.contentSize.height;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *returnedCell = nil;
    if (_expanded) {
        MWZUIOpeningHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"openingCell"];
        if (cell == nil) {
            cell = [[MWZUIOpeningHoursTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"openingCell"];
        }
        cell.dayLabel.text = _sortedIntervals[indexPath.row][@"day"];
        cell.hoursLabel.text = _sortedIntervals[indexPath.row][@"value"];
        if (indexPath.row == 0) {
            UIFontDescriptor * fontD = [cell.hoursLabel.font.fontDescriptor
                        fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
            cell.hoursLabel.font = [UIFont fontWithDescriptor:fontD size:14];
            cell.dayLabel.font = [UIFont fontWithDescriptor:fontD size:14];
            [cell.toggleImage setHidden:NO];
        }
        else {
            cell.hoursLabel.font = [cell.hoursLabel.font fontWithSize:14];
            cell.dayLabel.font = [cell.hoursLabel.font fontWithSize:14];
            [cell.toggleImage setHidden:YES];
        }
        cell.hoursLabel.numberOfLines = 0;
        returnedCell = cell;
    }
    else {
        MWZUIOpeningHoursTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCell"];
        if (cell == nil) {
            cell = [[MWZUIOpeningHoursTodayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todayCell"];
        }
        if (_openingHours.count > 0) {
            cell.hoursLabel.text = [MWZUIOpeningHoursUtils getCurrentOpeningStateString:_openingHours timezoneCode:_timezoneCode];
            cell.hoursLabel.font = [cell.hoursLabel.font fontWithSize:14];
            [cell.toggleImage setHidden:NO];
        }
        else {
            cell.hoursLabel.text = NSLocalizedString(@"Opening hours not available", @"");
            UIFontDescriptor * fontD = [cell.hoursLabel.font.fontDescriptor
                        fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
            cell.hoursLabel.font = [UIFont fontWithDescriptor:fontD size:14];
            cell.hoursLabel.textColor = [UIColor darkGrayColor];
            [cell.toggleImage setHidden:YES];
        }
        returnedCell = cell;
    }
    returnedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnedCell;
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

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}*/

@end
