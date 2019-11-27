#import <UIKit/UIKit.h>

#ifndef MWZScene_h
#define MWZScene_h


@protocol MWZScene <NSObject>

- (instancetype) initWith:(UIColor*) mainColor;

- (void) addTo:(UIView*) view;
- (void) setHidden:(BOOL) hidden;

@end


#endif
