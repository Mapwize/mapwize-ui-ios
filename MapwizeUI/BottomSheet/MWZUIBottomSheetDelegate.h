#ifndef MWZUIBottomSheetDelegate_h
#define MWZUIBottomSheetDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>
@class MWZUIBottomSheet;
@class MWZUIBottomSheetComponents;
#import "MWZUIPlaceMock.h"

@protocol MWZUIBottomSheetDelegate <NSObject>

- (MWZUIBottomSheetComponents*) requireComponentForPlace:(MWZPlace*)place withDefaultComponents:(MWZUIBottomSheetComponents*)components;

- (MWZUIBottomSheetComponents*) requireComponentForPlacelist:(MWZPlacelist*)placelist withDefaultComponents:(MWZUIBottomSheetComponents*)components;

@end

#endif /* MWZUIBottomSheetDelegate_h */
