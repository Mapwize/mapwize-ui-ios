#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MWZComponentQrCodeButtonDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MWZComponentQrCodeButton : UIButton

@property (nonatomic, weak) id<MWZComponentQrCodeButtonDelegate> delegate;

- (instancetype) init;

@end

NS_ASSUME_NONNULL_END
