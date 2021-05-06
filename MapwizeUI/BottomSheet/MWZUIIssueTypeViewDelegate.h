#ifndef MWZUIIssueTypeViewDelegate_h
#define MWZUIIssueTypeViewDelegate_h

#import <MapwizeSDK/MapwizeSDK.h>

@protocol MWZUIIssueTypeViewDelegate <NSObject>

- (void) didSelectIssueType:(MWZIssueType*)issueType;

@end


#endif
