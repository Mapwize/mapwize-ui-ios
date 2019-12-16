#ifndef MWZUISearchQueryBarDelegate_h
#define MWZUISearchQueryBarDelegate_h

@protocol MWZUISearchQueryBarDelegate <NSObject>

- (void) didTapOnBackButton;
- (void) searchQueryDidChange:(NSString*) query;

@end

#endif /* MWZSearchQueryBarDelegate_h */
