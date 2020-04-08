#import <Foundation/Foundation.h>
#import "MWZUIDirectionHeader.h"
#import "MWZUIDirectionHeaderDelegate.h"
#import "MWZUIScene.h"
#import "MWZUIDirectionSceneDelegate.h"
#import "MWZUIGroupedResultListDelegate.h"
#import "MWZUIDirectionInfo.h"
#import "MWZUIGroupedResultList.h"
#import "MWZUICurrentLocationView.h"

@import MapwizeSDK;

NS_ASSUME_NONNULL_BEGIN


@interface MWZUIDirectionScene : NSObject <MWZUIScene, MWZUIDirectionHeaderDelegate, MWZUIGroupedResultListDelegate>

@property (nonatomic, weak) id<MWZUIDirectionSceneDelegate> delegate;
@property (nonatomic) UIView* topConstraintView;
@property (nonatomic) UIView* resultListTopConstraintView;
@property (nonatomic) NSLayoutConstraint* resultListTopConstraint;
@property (nonatomic) NSLayoutConstraint* topConstraintViewMarginTop;
@property (nonatomic) MWZUIDirectionHeader* directionHeader;
@property (nonatomic) MWZUIDirectionInfo* directionInfo;
@property (nonatomic) MWZUIGroupedResultList* resultList;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic) UIColor* mainColor;
@property (nonatomic) MWZUICurrentLocationView* currentLocationView;

- (void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
- (void) setAvailableModes:(NSArray<MWZDirectionMode*>*) modes;
- (void) setSelectedMode:(MWZDirectionMode*) mode;

- (void) setInfoWith:(double) directionTravelTime
   directionDistance:(double) directionDistance
       directionMode:(MWZDirectionMode*) directionMode;

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
              withLanguage:(NSString*) language
                  forQuery:(NSString*) query;
- (void) setSearchResultsHidden:(BOOL) hidden;
- (void) setCurrentLocationViewHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
