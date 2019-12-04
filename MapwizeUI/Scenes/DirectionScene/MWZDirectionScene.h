#import <Foundation/Foundation.h>
#import "MWZDirectionHeader.h"
#import "MWZDirectionHeaderDelegate.h"
#import "MWZScene.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZComponentResultList.h"
#import "MWZComponentResultListDelegate.h"
#import "MWZComponentDirectionInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface MWZDirectionScene : NSObject <MWZScene, MWZDirectionHeaderDelegate, MWZComponentResultListDelegate>

@property (nonatomic, weak) id<MWZDirectionSceneDelegate> delegate;
@property (nonatomic) UIView* topConstraintView;
@property (nonatomic) NSLayoutConstraint* topConstraintViewMarginTop;
@property (nonatomic) MWZDirectionHeader* directionHeader;
@property (nonatomic) MWZComponentDirectionInfo* directionInfo;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) UIColor* mainColor;

- (void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setAccessibleMode:(BOOL) isAccessible;
- (void) setInfoWith:(double) directionTravelTime
   directionDistance:(double) directionDistance
        isAccessible:(BOOL) isAccessible;

- (void) setDirectionInfoHidden:(BOOL) hidden;
- (void) openFromSearch;
- (void) closeFromSearch;
- (void) openToSearch;
- (void) closeToSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results withLanguage:(NSString*) language;
- (void) setSearchResultsHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
