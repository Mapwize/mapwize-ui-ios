#import "MWZComponentFloorController.h"
#import "MWZComponentFloorView.h"

@import MapwizeSDK;

const int MWZComponentFloorViewSize = 40;
const int MWZComponentFloorViewMarginSize = 5;

@interface MWZComponentFloorController ()

@property (nonatomic) NSMutableArray* floorViews;
@property (nonatomic) NSMutableDictionary* floorViewByFloor;
@property (nonatomic) NSLayoutConstraint* heightConstraint;
@property (nonatomic) UIView* contentView;
@property (nonatomic, assign) int yAnchor;
@property (nonatomic, assign) int lastFrameHeight;
@property (nonatomic) MWZComponentFloorView* selectedView;
@property (nonatomic) UIColor* mainColor;

@end

@implementation MWZComponentFloorController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.floorViews = [[NSMutableArray alloc] init];
        self.floorViewByFloor = [[NSMutableDictionary alloc] init];
        self.contentView = [[UIView alloc] init];
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
            MWZComponentFloorView* floorView = [[MWZComponentFloorView alloc] initWithFrame:CGRectMake(4, self.yAnchor, 96, MWZComponentFloorViewSize) withIsSelected:selected mainColor:_mainColor];
            floorView.text = [NSString stringWithFormat:@"%@", @"Siham"];//floor.name];
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
            self.yAnchor += MWZComponentFloorViewSize + MWZComponentFloorViewMarginSize;
        }
    }
    
    self.yAnchor += 4;
    
    self.lastFrameHeight = self.frame.size.height;
    CGRect contentRect;
    if (self.yAnchor-MWZComponentFloorViewMarginSize < self.frame.size.height) {
        contentRect = CGRectMake(0, self.frame.size.height-self.yAnchor+MWZComponentFloorViewMarginSize, MWZComponentFloorViewSize, self.yAnchor-MWZComponentFloorViewMarginSize);
    }
    else {
        contentRect = CGRectMake(0, 0, MWZComponentFloorViewSize, self.yAnchor-MWZComponentFloorViewMarginSize);
    }
    self.contentView.frame = contentRect;
    self.contentSize = contentRect.size;
    
    [self scrollRectToVisible:self.selectedView.frame animated:NO];
    
    self.heightConstraint.constant = self.contentSize.height;
    [self.superview layoutIfNeeded];
    /*[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.heightConstraint.constant = self.contentSize.height;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];*/
    [self show];
}

- (void) show {
    for (MWZComponentFloorView* floorView in self.floorViews.reverseObjectEnumerator) {
        [floorView setTransform:CGAffineTransformMakeTranslation(self.frame.size.width,0)];
    }
    float i = 0.0f;
    for (MWZComponentFloorView* floorView in self.floorViews.reverseObjectEnumerator) {
        [UIView animateWithDuration:0.2f delay:i options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [floorView setTransform:CGAffineTransformMakeTranslation(0,0)];
        } completion:^(BOOL finished) {
            
        }];
        i += 0.05f;
    }

}

- (void) close {
    for (MWZComponentFloorView* floorView in self.floorViews) {
        [floorView setTransform:CGAffineTransformMakeTranslation(0,0)];
    }
    float i = 0.0f;
    for (MWZComponentFloorView* floorView in self.floorViews) {
        [UIView animateWithDuration:0.2f delay:i options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [floorView setTransform:CGAffineTransformMakeTranslation(self.frame.size.width,0)];
        } completion:^(BOOL finished) {
            
        }];
        i += 0.05f;
    }
}

- (void) mapwizeFloorDidChange:(MWZFloor*) floor {
    MWZComponentFloorView* floorView = self.floorViewByFloor[floor.number];
    
    for (MWZComponentFloorView *view in self.floorViews) {
        [view setSelected:NO];
        [floorView setPreselected:NO];
    }
    
    [floorView setSelected:YES];
}

- (void) mapwizeFloorWillChange:(MWZFloor*) floor {
    MWZComponentFloorView* floorView = self.floorViewByFloor[floor.number];
    
    for (MWZComponentFloorView *view in self.floorViews) {
        [view setSelected:NO];
        [floorView setPreselected:NO];
    }
    
    [floorView setPreselected:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    MWZComponentFloorView* floorView = (MWZComponentFloorView*)recognizer.view;
    [_floorControllerDelegate floorController:self didSelect:floorView.floor];
}

- (void) layoutSubviews {
    if (self.lastFrameHeight != self.frame.size.height) {
        CGRect contentRect;
        if (self.frame.size.height > self.yAnchor - MWZComponentFloorViewMarginSize) {
            contentRect = CGRectMake(0, self.frame.size.height-self.yAnchor+MWZComponentFloorViewMarginSize, MWZComponentFloorViewSize + 8, self.yAnchor-MWZComponentFloorViewMarginSize);
        }
        else {
            contentRect = CGRectMake(0, 0, MWZComponentFloorViewSize + 8, self.yAnchor-MWZComponentFloorViewMarginSize);
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
