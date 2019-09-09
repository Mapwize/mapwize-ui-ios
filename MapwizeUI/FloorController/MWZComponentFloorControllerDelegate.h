#ifndef MWZComponentFloorControllerDelegate_h
#define MWZComponentFloorControllerDelegate_h

@class MWZComponentFloorController;

@protocol MWZComponentFloorControllerDelegate <NSObject>

- (void) floorController:(MWZComponentFloorController*) floorController didSelect:(NSNumber*) floorOrder;

@end

#endif
