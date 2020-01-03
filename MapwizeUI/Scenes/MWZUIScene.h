#import <UIKit/UIKit.h>

#ifndef MWZUIScene_h
#define MWZUIScene_h


@protocol MWZUIScene <NSObject>

- (instancetype) initWith:(UIColor*) mainColor;

- (void) addTo:(UIView*) view;
- (void) setHidden:(BOOL) hidden;
- (UIView*) getTopViewToConstraint;
- (UIView*) getBottomViewToConstraint;

@end


#endif
