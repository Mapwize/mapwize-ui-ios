//
//  MWZMapViewMenuBarDelegate.h
//  MapwizeUI
//
//  Created by Etienne on 29/10/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

#ifndef MWZUIMapViewMenuBarDelegate_h
#define MWZUIMapViewMenuBarDelegate_h

@protocol MWZUIMapViewMenuBarDelegate <NSObject>

- (void) didTapOnSearchButton;
- (void) didTapOnMenuButton;
- (void) didTapOnDirectionButton;

@end

#endif /* MWZMapViewMenuBarDelegate_h */
