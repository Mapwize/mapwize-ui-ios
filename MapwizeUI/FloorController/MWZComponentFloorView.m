#import "MWZComponentFloorView.h"

@implementation MWZComponentFloorView

- (instancetype) initWithFrame:(CGRect) frame withIsSelected:(BOOL) isSelected {
    self = [super initWithFrame:frame];
    _selected = isSelected;
    
    if (_selected) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f].CGColor;
    }
    else {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    
    self.textAlignment = NSTextAlignmentCenter;
    return self;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds = false;
    self.layer.cornerRadius = rect.size.height/2;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void) setPreselected:(BOOL) preselected {
    if (preselected) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f].CGColor;
    }
    else {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    self.layer.masksToBounds = false;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void) setSelected:(BOOL)selected {
    _selected = selected;
    
    if (_selected) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f].CGColor;
    }
    else {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    self.layer.masksToBounds = false;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
}

@end
