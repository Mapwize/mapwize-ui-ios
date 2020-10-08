//
//  MWZUICollectionViewCell.m
//  BottomSheet
//
//  Created by Etienne on 28/09/2020.
//

#import "MWZUICollectionViewCell.h"

@implementation MWZUICollectionViewCell

// Lazy loading of the imageView
- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
     }
     return _imageView;
 }

// Here we remove all the custom stuff that we added to our subclassed cell
-(void)prepareForReuse
{
    [super prepareForReuse];

    /*[self.imageView removeFromSuperview];
    self.imageView = nil;*/
}

@end
