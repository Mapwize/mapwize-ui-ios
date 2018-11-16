#import "MWZComponentColors.h"

@implementation MWZComponentColors

+ (UIImage *)tintedBackgroundImageWithImage:(UIImage*) input tint:(UIColor *)color {
    UIImage *image;
    if (color) {
        // Construct new image the same size as this one.
        UIGraphicsBeginImageContextWithOptions([input size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
        CGRect rect = CGRectZero;
        rect.size = [input size];
        
        // tint the image
        [input drawInRect:rect];
        [color set];
        UIRectFillUsingBlendMode(rect, kCGBlendModeScreen);
        
        // restore alpha channel
        [input drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}


@end
