#import "MWZUIPagerView.h"
#import "MWZUIPagerHeaderView.h"
#import "MWZUIPagerHeaderTitle.h"
#import "MWZUIPagerHeaderViewDelegate.h"

@interface MWZUIPagerView() <UIScrollViewDelegate, UIGestureRecognizerDelegate, MWZUIPagerHeaderViewDelegate>

@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) MWZUIPagerHeaderView* pagerHeader;
@property (nonatomic) NSMutableArray<UIView*>* slides;
@property (nonatomic) NSMutableArray<NSString*>* slideNames;

@end

@implementation MWZUIPagerView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color {
    self = [super initWithFrame:frame];
    if (self) {
        _slides = [[NSMutableArray alloc] init];
        _slideNames = [[NSMutableArray alloc] init];
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _pagerHeader = [[MWZUIPagerHeaderView alloc] initWithColor:color];
        _pagerHeader.translatesAutoresizingMaskIntoConstraints = NO;
        _pagerHeader.delegate = self;
    }
    return self;
}

- (void) addSlide:(UIView*)slide named:(NSString*)slideName {
    [_slides addObject:slide];
    [_slideNames addObject:slideName];
}

- (void) build {
    if (_slides.count > 1) {
        [self addSubview:_pagerHeader];
        [[_pagerHeader.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_pagerHeader.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[_pagerHeader.heightAnchor constraintEqualToConstant:48] setActive:YES];
        [self addSubview:_scrollView];
        [[_scrollView.topAnchor constraintEqualToAnchor:_pagerHeader.bottomAnchor constant:16] setActive:YES];
        [[_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    }
    else {
        [self addSubview:_scrollView];
        [[_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_scrollView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    }
    UIView* lastSlide = nil;
    NSMutableArray<MWZUIPagerHeaderTitle*>* headerTitles = [[NSMutableArray alloc] init];
    for (int i=0; i<_slides.count; i++) {
        UIView* slide = _slides[i];
        NSString* slideName = _slideNames[i];
        [headerTitles addObject:[[MWZUIPagerHeaderTitle alloc] initWithIndex:[NSNumber numberWithInt:i] title:slideName]];
        slide.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:slide];
        [[slide.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor] setActive:YES];
        [[slide.topAnchor constraintEqualToAnchor:_scrollView.topAnchor] setActive:YES];
        [[slide.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        if (lastSlide) {
            [[slide.leadingAnchor constraintEqualToAnchor:lastSlide.trailingAnchor] setActive:YES];
        }
        else {
            [[slide.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor] setActive:YES];
        }
        lastSlide = slide;
    }
    [[lastSlide.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor] setActive:YES];
    [_pagerHeader setTitles:headerTitles];
}

- (void) log {
    NSLog(@"%f %f",self.frame.size.height,self.frame.size.width);
    NSLog(@"%f %f",_scrollView.contentSize.height,_scrollView.contentSize.width);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    int index = (int)(targetContentOffset->x / self.frame.size.width);
    [_pagerHeader setSelectedIndex:[NSNumber numberWithInt:index]];
}

- (void)pagerHeader:(MWZUIPagerHeaderView *)pagerHeader didChangeTitle:(MWZUIPagerHeaderTitle *)title {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * [title.index doubleValue], 0) animated:YES];
}

@end
