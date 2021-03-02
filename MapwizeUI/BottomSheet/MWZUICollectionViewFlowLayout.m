#import "MWZUICollectionViewFlowLayout.h"

@implementation MWZUICollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    CGFloat leftMargin = self.sectionInset.left; //initalized to silence compiler, and actaully safer, but not planning to use.
    CGFloat maxY = -1.0f;

    //this loop assumes attributes are in IndexPath order
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.frame.origin.y >= maxY) {
            leftMargin = self.sectionInset.left;
        }

        attribute.frame = CGRectMake(leftMargin, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);

        leftMargin += attribute.frame.size.width + self.minimumInteritemSpacing;
        maxY = MAX(CGRectGetMaxY(attribute.frame), maxY);
    }

    return attributes;
}

@end
