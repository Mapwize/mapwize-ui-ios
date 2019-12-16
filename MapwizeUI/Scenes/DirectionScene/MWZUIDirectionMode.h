#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MWZUIDirectionMode : NSObject

@property (nonatomic) UIImage* image;
@property (assign) BOOL isAccessible;

- (instancetype) initWithImage:(UIImage*) image isAccessible:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
