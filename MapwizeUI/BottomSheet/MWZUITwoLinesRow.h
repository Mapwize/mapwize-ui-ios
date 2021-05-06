#import <Foundation/Foundation.h>

#import "MWZUIFullContentViewComponentRow.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MWZUITextFieldRowDelegate <NSObject>

- (void) didChangeInput:(NSString*)value;

@end

@interface MWZUITwoLinesRow : MWZUIFullContentViewComponentRow

@property (nonatomic, weak) id<MWZUITextFieldRowDelegate> delegate;

- (instancetype) initWithImage:(UIImage*)image label:(NSString*)label view:(UIView*)view color:(UIColor*)color;

- (void) setErrorMessage:(NSString*)message;

@end


NS_ASSUME_NONNULL_END
