#import <Foundation/Foundation.h>
#import "MWZDirectionHeader.h"
#import "MWZDirectionHeaderDelegate.h"
#import "MWZScene.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZComponentResultList.h"
#import "MWZComponentGroupedResultListDelegate.h"
#import "MWZComponentDirectionInfo.h"
#import "MWZComponentGroupedResultList.h"
#import "MWZComponentCurrentLocationView.h"

NS_ASSUME_NONNULL_BEGIN


@interface MWZDirectionScene : NSObject <MWZScene, MWZDirectionHeaderDelegate, MWZComponentGroupedResultListDelegate>

@property (nonatomic, weak) id<MWZDirectionSceneDelegate> delegate;
@property (nonatomic) UIView* topConstraintView;
@property (nonatomic) UIView* resultListTopConstraintView;
@property (nonatomic) NSLayoutConstraint* resultListTopConstraint;
@property (nonatomic) NSLayoutConstraint* topConstraintViewMarginTop;
@property (nonatomic) MWZDirectionHeader* directionHeader;
@property (nonatomic) MWZComponentDirectionInfo* directionInfo;
@property (nonatomic) MWZComponentGroupedResultList* resultList;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) UIColor* mainColor;
@property (nonatomic) MWZComponentCurrentLocationView* currentLocationView;

- (void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setAccessibleMode:(BOOL) isAccessible;
- (void) setInfoWith:(double) directionTravelTime
   directionDistance:(double) directionDistance
        isAccessible:(BOOL) isAccessible;

- (void) showLoading;
- (void) hideLoading;
- (void) showErrorMessage:(NSString*) errorMessage;
- (void) setDirectionInfoHidden:(BOOL) hidden;
- (void) openFromSearch;
- (void) closeFromSearch;
- (void) openToSearch;
- (void) closeToSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results
                 universes:(NSArray<MWZUniverse*>*) universes
            activeUniverse:(MWZUniverse*) activeUniverse
              withLanguage:(NSString*) language;
- (void) setSearchResultsHidden:(BOOL) hidden;
- (void) setCurrentLocationViewHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
