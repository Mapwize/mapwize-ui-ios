#ifndef MWZUIEventChannel_h
#define MWZUIEventChannel_h

#import <Foundation/Foundation.h>

/**
 Enum to identify how a place or placelist has been selected
 */
typedef NS_ENUM(NSUInteger, MWZUIEventChannel) {
    /// The user click on the place icon
    MWZUIEventChannelMapClick,
    /// The user select the place in the search result list
    MWZUIEventChannelSearch,
    /// The user select the place in the main search list
    MWZUIEventChannelMainSearch
};

#endif
