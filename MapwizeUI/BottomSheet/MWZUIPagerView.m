#import "MWZUIPagerView.h"

@interface MWZUIPagerView()

@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIStackView* stackView;
@property (nonatomic) NSMutableArray<UIView*>* slides;
@property (nonatomic) NSMutableArray<NSString*>* slideNames;

@end

@implementation MWZUIPagerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _slides = [[NSMutableArray alloc] init];
        _slideNames = [[NSMutableArray alloc] init];
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.pagingEnabled = YES;
        _stackView = [[UIStackView alloc] initWithFrame:frame];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void) addSlide:(UIView*)slide named:(NSString*)slideName {
    [_slides addObject:slide];
    [_slideNames addObject:slideName];
}

- (void) build {
    if (_slides.count > 1) {
        [self addSubview:_stackView];
        [[_stackView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        _stackView.backgroundColor = [UIColor redColor];
        [self addSubview:_scrollView];
        [[_scrollView.topAnchor constraintEqualToAnchor:_stackView.bottomAnchor] setActive:YES];
        [[_scrollView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    }
    else {
        [self addSubview:_scrollView];
        [[_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_scrollView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    }
    
}

@end
