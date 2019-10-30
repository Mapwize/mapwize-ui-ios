#ifndef MWZSearchQueryBarDelegate_h
#define MWZSearchQueryBarDelegate_h

@protocol MWZSearchQueryBarDelegate <NSObject>

- (void) didTapOnBackButton;
- (void) searchQueryDidChange:(NSString*) query;

@end

#endif /* MWZSearchQueryBarDelegate_h */
