#import <UIKit/UIKit.h>
#import "MWZDirectionHeaderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class MWZComponentBorderedTextField;

@interface MWZDirectionHeader : UIView

@property (nonatomic, weak) id<MWZDirectionHeaderDelegate> delegate;

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setAccessibleMode:(BOOL) isAccessible;

@end

NS_ASSUME_NONNULL_END
