#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MWZUIFullContentViewComponentRowType) {
    MWZUIFullContentViewComponentRowOpeningHours,
    MWZUIFullContentViewComponentRowPhoneNumber,
    MWZUIFullContentViewComponentRowWebsite,
    MWZUIFullContentViewComponentRowSchedule,
    MWZUIFullContentViewComponentRowCustom
};


@interface MWZUIFullContentViewComponentRow : UIView

@property (nonatomic) UIImage* image;
@property (nonatomic) UIView* contentView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic) MWZUIFullContentViewComponentRowType type;
@property (nonatomic, assign) BOOL infoAvailable;

- (instancetype) initWithImage:(UIImage*)image contentView:(UIView*)contentView color:(UIColor*)color tapGestureRecognizer:(nullable UITapGestureRecognizer*)tapGestureRecognizer type:(MWZUIFullContentViewComponentRowType)type infoAvailable:(BOOL) infoAvailable;

@end

NS_ASSUME_NONNULL_END
