//
//  MWZUIOpeningHoursTableViewCell.h
//  BottomSheet
//
//  Created by Etienne on 02/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIOpeningHoursTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel* dayLabel;
@property (nonatomic, retain) UILabel* hoursLabel;
@property (nonatomic, retain) UIImageView* toggleImage;

@end

NS_ASSUME_NONNULL_END
