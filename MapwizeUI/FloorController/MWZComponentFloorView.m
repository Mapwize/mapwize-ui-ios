#import "MWZComponentFloorView.h"

@implementation MWZComponentFloorView {
    CALayer* _haloLayer;
}

- (instancetype) initWithFrame:(CGRect) frame
                withIsSelected:(BOOL) isSelected
                     mainColor:(UIColor*) mainColor{
    self = [super initWithFrame:frame];
    _selected = isSelected;
    _mainColor = mainColor;
    
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
        //self.layer.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f].CGColor;
        [self addHaloLayer];
    }
    else {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self removeHaloLayer];
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
        self.layer.backgroundColor = _mainColor.CGColor;
        self.textColor = [UIColor whiteColor];
    }
    else {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.textColor = [UIColor blackColor];
    }
    self.layer.masksToBounds = false;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
}

- (void) removeHaloLayer {
    if (_haloLayer) {
        [_haloLayer removeFromSuperlayer];
        _haloLayer = nil;
    }
}

- (void) addHaloLayer {
    _haloLayer = [self circleLayerWithSize:self.frame.size.height];
    _haloLayer.backgroundColor = _mainColor.CGColor;
    _haloLayer.allowsGroupOpacity = NO;
    _haloLayer.zPosition = 0.1f;
    
    // set defaults for the animations
    CAAnimationGroup *animationGroup = [self loopingAnimationGroupWithDuration:2.0];
    
    // scale out radially with initial acceleration
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    boundsAnimation.values = @[@0, @1, @0.0];
    boundsAnimation.keyTimes = @[@0, @0.5, @1];
    
    // go transparent as scaled out, start semi-opaque
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@0.4, @0.4, @0.4];
    opacityAnimation.keyTimes = @[@0, @0.2, @1];
    
    animationGroup.animations = @[boundsAnimation, opacityAnimation];
    
    [_haloLayer addAnimation:animationGroup forKey:@"animateTransformAndOpacity"];
    
    [self.layer addSublayer:_haloLayer];
}

- (CALayer *)circleLayerWithSize:(CGFloat)layerSize
{
    layerSize = round(layerSize);
    
    CALayer *circleLayer = [CALayer layer];
    circleLayer.bounds = CGRectMake(0, 0, layerSize, layerSize);
    circleLayer.position = CGPointMake(CGRectGetMidX(super.bounds), CGRectGetMidY(super.bounds));
    circleLayer.cornerRadius = layerSize / 2.0;
    circleLayer.shouldRasterize = YES;
    circleLayer.rasterizationScale = [UIScreen mainScreen].scale;
    circleLayer.drawsAsynchronously = YES;
    
    return circleLayer;
}

- (CAAnimationGroup *)loopingAnimationGroupWithDuration:(CGFloat)animationDuration
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    return animationGroup;
}

@end
