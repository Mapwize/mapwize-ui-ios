#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Define MapwizeUI defined row type
 */
typedef NS_ENUM(NSUInteger, MWZUIFullContentViewComponentRowType) {
    MWZUIFullContentViewComponentRowOpeningHours,
    MWZUIFullContentViewComponentRowPhoneNumber,
    MWZUIFullContentViewComponentRowWebsite,
    MWZUIFullContentViewComponentRowSchedule,
    MWZUIFullContentViewComponentRowCustom
};

/**
 MWZUIFullContentViewComponentRow is the component that display a custom information as a row in the expanded bottom view
 */
@interface MWZUIFullContentViewComponentRow : UIView

@property (nonatomic) UIImage* image;
@property (nonatomic) UIView* contentView;
@property (nonatomic) UIColor* color;
@property (nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic) MWZUIFullContentViewComponentRowType type;
@property (nonatomic, assign) BOOL infoAvailable;

/**
 Creates a MWZUIIconTextButton
 @param image show on the left on the button
 @param contentView the view that will be display in the row
 @param color of the button
 @param tapGestureRecognizer added to the row to respond to clic event
 @param type the MWZUIFullContentViewComponentRowType. You should use custom if you are using a custom row
 @param infoAvailable if false, the content will be replaced by a place holder
 */
- (instancetype) initWithImage:(UIImage*)image contentView:(UIView*)contentView color:(UIColor*)color tapGestureRecognizer:(nullable UITapGestureRecognizer*)tapGestureRecognizer type:(MWZUIFullContentViewComponentRowType)type infoAvailable:(BOOL) infoAvailable;

@end

NS_ASSUME_NONNULL_END
