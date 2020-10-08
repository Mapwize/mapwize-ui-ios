//
//  MWZUIOpeningHoursView.h
//  BottomSheet
//
//  Created by Etienne on 30/09/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIOpeningHoursView : UIView

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic) NSArray* openingHours;

- (void) toggleExpanded;

@end

NS_ASSUME_NONNULL_END
