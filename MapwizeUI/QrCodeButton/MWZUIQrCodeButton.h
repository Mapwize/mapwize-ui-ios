#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MWZUIQrCodeButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZUIQrCodeButton : UIButton

@property (nonatomic, weak) id<MWZUIQrCodeButtonDelegate> delegate;

- (instancetype) init;

@end

NS_ASSUME_NONNULL_END
