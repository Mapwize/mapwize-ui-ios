#ifndef MWZUIPagerHeaderViewDelegate_h
#define MWZUIPagerHeaderViewDelegate_h

@class MWZUIPagerHeaderView;
@class MWZUIPagerHeaderTitle;

@protocol MWZUIPagerHeaderViewDelegate <NSObject>

- (void) pagerHeader:(MWZUIPagerHeaderView*) pagerHeader didChangeTitle:(MWZUIPagerHeaderTitle*) title;

@end

#endif /* MWZUIPagerHeaderViewDelegate_h */
