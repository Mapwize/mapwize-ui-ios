#import "MWZUIFloorController.h"
#import "MWZUIFloorView.h"

@import MapwizeSDK;

const int MWZUIFloorViewWidth = 40;
const int MWZUIFloorViewHeight = 40;
const int MWZUIFloorViewMarginSize = 4;

@interface MWZUIFloorController ()

@property (nonatomic) NSMutableArray* floorViews;
@property (nonatomic) NSMutableDictionary* floorViewByFloor;
@property (nonatomic) NSLayoutConstraint* heightConstraint;
@property (nonatomic) UIView* contentView;
@property (nonatomic, assign) int yAnchor;
@property (nonatomic, assign) int lastFrameHeight;
@property (nonatomic) MWZUIFloorView* selectedView;
@property (nonatomic) UIColor* mainColor;

@end

@implementation MWZUIFloorController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.floorViews = [[NSMutableArray alloc] init];
        self.floorViewByFloor = [[NSMutableDictionary alloc] init];
        self.contentView = [[UIView alloc] init];
        self.showsVerticalScrollIndicator = NO;
        [self addSubview:self.contentView];
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:0.0f];
        self.heightConstraint.priority = 600;
        [self.heightConstraint setActive:YES];
    }
    return self;
}

- (instancetype) initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        _floorViews = [[NSMutableArray alloc] init];
        _floorViewByFloor = [[NSMutableDictionary alloc] init];
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:0.0f];
        _heightConstraint.priority = 600;
        [_heightConstraint setActive:YES];
        _mainColor = color;
    }
    return self;
}

- (void) mapwizeFloorsDidChange:(NSArray<MWZFloor*>*) floors showController:(BOOL) showController {
    if (!floors || floors.count == 0 || !showController) {
        [self close];
        return;
    }
    NSArray* reversedFloors = [[floors reverseObjectEnumerator] allObjects];
    
    [self.floorViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.floorViews = [[NSMutableArray alloc] init];
    self.floorViewByFloor = [[NSMutableDictionary alloc] init];
    self.yAnchor = 0;
    if (reversedFloors) {
        for (MWZFloor* floor in reversedFloors) {
            BOOL selected = NO;
            MWZUIFloorView* floorView = [[MWZUIFloorView alloc] initWithFrame:CGRectMake(4, self.yAnchor, MWZUIFloorViewWidth, MWZUIFloorViewHeight) withIsSelected:selected mainColor:_mainColor];
            floorView.text = [NSString stringWithFormat:@"%@", floor.name];
            floorView.floor = floor.number;
            floorView.userInteractionEnabled = YES;
            [self.contentView addSubview:floorView];
            [self.floorViews addObject:floorView];
            self.floorViewByFloor[floor.number] = floorView;
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [floorView addGestureRecognizer:singleFingerTap];
            
            if (selected) {
                self.selectedView = floorView;
            }
            self.yAnchor += MWZUIFloorViewHeight + MWZUIFloorViewMarginSize;
        }
    }
    
    self.yAnchor += 4;
    
    self.lastFrameHeight = self.frame.size.height;
    CGRect contentRect;
    if (self.yAnchor-MWZUIFloorViewMarginSize < self.frame.size.height) {
        contentRect = CGRectMake(0, self.frame.size.height-self.yAnchor+MWZUIFloorViewMarginSize, MWZUIFloorViewHeight, self.yAnchor-MWZUIFloorViewMarginSize);
    }
    else {
        contentRect = CGRectMake(0, 0, MWZUIFloorViewHeight, self.yAnchor-MWZUIFloorViewMarginSize);
    }
    self.contentView.frame = contentRect;
    self.contentSize = contentRect.size;
    
    [self scrollRectToVisible:self.selectedView.frame animated:NO];
    
    self.heightConstraint.constant = self.contentSize.height;
    [self.superview layoutIfNeeded];
    [self show];
}

- (void) show {
    for (MWZUIFloorView* floorView in self.floorViews.reverseObjectEnumerator) {
        [floorView setTransform:CGAffineTransformMakeTranslation(self.frame.size.width,0)];
    }
    float i = 0.0f;
    for (MWZUIFloorView* floorView in self.floorViews.reverseObjectEnumerator) {
        [UIView animateWithDuration:0.2f delay:i options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [floorView setTransform:CGAffineTransformMakeTranslation(0,0)];
        } completion:^(BOOL finished) {
            
        }];
        i += 0.05f;
    }

}

- (void) close {
    for (MWZUIFloorView* floorView in self.floorViews) {
        [floorView setTransform:CGAffineTransformMakeTranslation(0,0)];
    }
    float i = 0.0f;
    for (MWZUIFloorView* floorView in self.floorViews) {
        [UIView animateWithDuration:0.2f delay:i options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [floorView setTransform:CGAffineTransformMakeTranslation(self.frame.size.width,0)];
        } completion:^(BOOL finished) {
            
        }];
        i += 0.05f;
    }
}

- (void) mapwizeFloorDidChange:(MWZFloor*) floor {
    MWZUIFloorView* floorView = self.floorViewByFloor[floor.number];
    
    for (MWZUIFloorView *view in self.floorViews) {
        [view setSelected:NO];
        [floorView setPreselected:NO];
    }
    [floorView setSelected:YES];
    [self scrollRectToVisible:floorView.frame animated:NO];
}

- (void) mapwizeFloorWillChange:(MWZFloor*) floor {
    MWZUIFloorView* floorView = self.floorViewByFloor[floor.number];
    
    for (MWZUIFloorView *view in self.floorViews) {
        [view setSelected:NO];
        [floorView setPreselected:NO];
    }
    
    [floorView setPreselected:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    MWZUIFloorView* floorView = (MWZUIFloorView*)recognizer.view;
    [_floorControllerDelegate floorController:self didSelect:floorView.floor];
}

- (void) layoutSubviews {
    if (self.lastFrameHeight != self.frame.size.height) {
        CGRect contentRect;
        if (self.frame.size.height > self.yAnchor - MWZUIFloorViewMarginSize) {
            contentRect = CGRectMake(0, self.frame.size.height-self.yAnchor+MWZUIFloorViewMarginSize, MWZUIFloorViewHeight + 8, self.yAnchor-MWZUIFloorViewMarginSize);
        }
        else {
            contentRect = CGRectMake(0, 0, MWZUIFloorViewHeight + 8, self.yAnchor-MWZUIFloorViewMarginSize);
        }
        self.contentSize = contentRect.size;
        self.contentView.frame = contentRect;
        self.contentSize = contentRect.size;
        self.lastFrameHeight = self.frame.size.height;
        [self scrollRectToVisible:self.selectedView.frame animated:NO];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return false;
}

@end
