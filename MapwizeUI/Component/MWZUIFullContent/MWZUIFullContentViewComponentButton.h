//
//  MWZUIRoundedButtonIconText.h
//  BottomSheet
//
//  Created by Etienne on 30/09/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MWZUIFullContentViewComponentButtonType) {
    MWZUIFullContentViewComponentButtonDirection,
    MWZUIFullContentViewComponentButtonPhone,
    MWZUIFullContentViewComponentButtonWebsite,
    MWZUIFullContentViewComponentButtonShare,
    MWZUIFullContentViewComponentButtonCustom
};

@interface MWZUIFullContentViewComponentButton : UIButton

- (instancetype)initWithTitle:(NSString*) text image:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined;

@end

NS_ASSUME_NONNULL_END
