#import "MWZComponentFloorController.h"
#import "MWZComponentFloorView.h"

const int MWZComponentFloorViewSize = 40;
const int MWZComponentFloorViewMarginSize = 5;

@implementation MWZComponentFloorController {
    NSMutableArray* floorViews;
    NSMutableDictionary* floorViewByFloor;
    NSLayoutConstraint* heightConstraint;
    UIView* contentView;
    int yAnchor;
    int lastFrameHeight;
    MWZComponentFloorView* selectedView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        floorViews = [[NSMutableArray alloc] init];
        floorViewByFloor = [[NSMutableDictionary alloc] init];
        contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:0.0f];
        heightConstraint.priority = 600;
        [heightConstraint setActive:YES];
    }
    return self;
}

- (void) mapwizeFloorsDidChange:(NSArray<NSNumber*>*) floors showController:(BOOL) showController {
    if (!floors || floors.count == 0 || !showController) {
        [self close];
        return;
    }
    [floorViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    floorViews = [[NSMutableArray alloc] init];
    floorViewByFloor = [[NSMutableDictionary alloc] init];
    yAnchor = 0;
    if (floors) {
        for (NSNumber* floor in floors) {
            BOOL selected = ([floor isEqualToNumber:[_mapwizePlugin getFloor]]?YES:NO);
            MWZComponentFloorView* floorView = [[MWZComponentFloorView alloc] initWithFrame:CGRectMake(4, yAnchor, MWZComponentFloorViewSize, MWZComponentFloorViewSize) withIsSelected:selected];
            floorView.text = [NSString stringWithFormat:@"%@", floor];
            floorView.floor = floor;
            floorView.userInteractionEnabled = YES;
            [contentView addSubview:floorView];
            [floorViews addObject:floorView];
            floorViewByFloor[floor] = floorView;
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [floorView addGestureRecognizer:singleFingerTap];
            
            if (selected) {
                selectedView = floorView;
            }
            yAnchor += MWZComponentFloorViewSize + MWZComponentFloorViewMarginSize;
        }
    }
    
    yAnchor += 4;
    
    lastFrameHeight = self.frame.size.height;
    CGRect contentRect;
    if (yAnchor-MWZComponentFloorViewMarginSize < self.frame.size.height) {
        contentRect = CGRectMake(0, self.frame.size.height-yAnchor+MWZComponentFloorViewMarginSize, MWZComponentFloorViewSize + 8, yAnchor-MWZComponentFloorViewMarginSize);
    }
    else {
        contentRect = CGRectMake(0, 0, MWZComponentFloorViewSize + 8, yAnchor-MWZComponentFloorViewMarginSize);
    }
    contentView.frame = contentRect;
    self.contentSize = contentRect.size;
    
    [self scrollRectToVisible:selectedView.frame animated:NO];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self->heightConstraint.constant = self.contentSize.height;
        [self.superview layoutIfNeeded];
    }];
}

- (void) close {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self->heightConstraint.constant = 0;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self->floorViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self->floorViews removeAllObjects];
        [self->floorViewByFloor removeAllObjects];
    }];
}

- (void) mapwizeFloorDidChange:(NSNumber*) floor {
    MWZComponentFloorView* floorView = floorViewByFloor[floor];
    
    for (MWZComponentFloorView *view in floorViews) {
        [view setSelected:NO];
    }
    
    [floorView setSelected:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    MWZComponentFloorView* floorView = (MWZComponentFloorView*)recognizer.view;
    [_mapwizePlugin setFloor:floorView.floor];
}

- (void) layoutSubviews {
    if (lastFrameHeight != self.frame.size.height) {
        CGRect contentRect;
        if (self.frame.size.height > yAnchor - MWZComponentFloorViewMarginSize) {
            contentRect = CGRectMake(0, self.frame.size.height-yAnchor+MWZComponentFloorViewMarginSize, MWZComponentFloorViewSize + 8, yAnchor-MWZComponentFloorViewMarginSize);
        }
        else {
            contentRect = CGRectMake(0, 0, MWZComponentFloorViewSize + 8, yAnchor-MWZComponentFloorViewMarginSize);
        }
        self.contentSize = contentRect.size;
        contentView.frame = contentRect;
        self.contentSize = contentRect.size;
        lastFrameHeight = self.frame.size.height;
        [self scrollRectToVisible:selectedView.frame animated:NO];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return false;
}

@end
