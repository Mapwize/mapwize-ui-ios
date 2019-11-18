#import <Foundation/Foundation.h>
#import "MWZDirectionHeader.h"
#import "MWZDirectionHeaderDelegate.h"
#import "MWZScene.h"
#import "MWZDirectionSceneDelegate.h"
#import "MWZComponentResultList.h"
#import "MWZComponentResultListDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface MWZDirectionScene : NSObject <MWZScene, MWZDirectionHeaderDelegate, MWZComponentResultListDelegate>

@property (nonatomic, weak) id<MWZDirectionSceneDelegate> delegate;
@property (nonatomic) MWZDirectionHeader* directionHeader;
@property (nonatomic) MWZComponentResultList* resultList;
@property (nonatomic) UIView* backgroundView;

-(void) setFromText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setToText:(NSString*) text asPlaceHolder:(BOOL) asPlaceHolder;
-(void) setAccessibleMode:(BOOL) isAccessible;

- (void) openFromSearch;
- (void) closeFromSearch;
- (void) openToSearch;
- (void) closeToSearch;
- (void) showSearchResults:(NSArray<id<MWZObject>>*) results withLanguage:(NSString*) language;
- (void) setSearchResultsHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
