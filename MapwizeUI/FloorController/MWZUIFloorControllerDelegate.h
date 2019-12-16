#ifndef MWZUIFloorControllerDelegate_h
#define MWZUIFloorControllerDelegate_h

@class MWZUIFloorController;

@protocol MWZUIFloorControllerDelegate <NSObject>

- (void) floorController:(MWZUIFloorController*) floorController didSelect:(NSNumber*) floorOrder;

@end

#endif
