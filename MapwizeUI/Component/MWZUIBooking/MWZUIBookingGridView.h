//
//  MWZUIBookingGridView.h
//  BottomSheet
//
//  Created by Etienne on 01/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIBookingGridView : UIView

@property (nonatomic) UIColor* color;

- (instancetype)initWithFrame:(CGRect)frame gridWidth:(double)gridWidth color:(UIColor*)color;

- (void) setCurrentTime:(double)hours events:(NSArray<NSDictionary*>*)events;

@end

NS_ASSUME_NONNULL_END
