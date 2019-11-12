#import "MWZMapViewController.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"
#import "MWZDirectionScene.h"

@interface MWZMapViewController ()

@property (nonatomic) MWZSceneCoordinator* sceneCoordinator;
@property (nonatomic) MWZSearchScene* searchScene;
@property (nonatomic) MWZDefaultScene* defaultScene;
@property (nonatomic) MWZDirectionScene* directionScene;

@property (nonatomic) NSArray<MWZVenue*>* mainVenues;
@property (nonatomic) NSArray<id<MWZObject>>* mainSearches;
@property (nonatomic) id<MWZObject> selectedContent;

@end

@implementation MWZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self fetchDefaultVenueSearch];
}

- (void) initialize {
    
    self.mapView = [[MWZMapView alloc] initWithFrame:self.view.frame options:[[MWZOptions alloc] init]];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.mapView];

    self.sceneCoordinator = [[MWZSceneCoordinator alloc] initWithContainerView:self.view];
    
    self.defaultScene = [[MWZDefaultScene alloc] init];
    self.defaultScene.delegate = self;
    self.sceneCoordinator.defaultScene = self.defaultScene;
    
    self.searchScene = [[MWZSearchScene alloc] init];
    self.searchScene.delegate = self;
    self.sceneCoordinator.searchScene = self.searchScene;
    
    self.directionScene = [[MWZDirectionScene alloc] init];
    self.directionScene.delegate = self;
    self.sceneCoordinator.directionScene = self.directionScene;
    
}

#pragma mark Search initialization
- (void) fetchDefaultVenueSearch {
    MWZSearchParams* params = [[MWZSearchParams alloc] init];
    params.query = @"";
    params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
    params.venueId = self.mapView.mapOptions.restrictContentToVenueId;
    params.objectClass = @[@"venue"];
    [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
        self.mainVenues = searchResponse;
    } failure:^(NSError *error) {
        self.mainVenues = @[];
    }];
}

- (void) fetchMainSearchesForVenues:(MWZVenue*) venue {
    [self.mapView.mapwizeApi getMainSearchesWithVenue:venue success:^(NSArray<MWZPlace *> *places) {
        self.mainSearches = places;
    } failure:^(NSError *error) {
        self.mainSearches = @[];
    }];
}

#pragma mark Scene transitions
- (void) mapToSearchTransition {
    [self.sceneCoordinator transitionFromDefaultToSearch];
}

- (void) searchToMapTransition {
    [self.sceneCoordinator transitionFromSearchToDefault];
}

- (void) defaultToDirectionTransition {
    [self.sceneCoordinator transitionFromDefaultToDirection];
}

- (void) directionToDefaultTransition {
    [self.sceneCoordinator transitionFromDirectionToDefault];
}

- (void) directionToSearchTransition {
    /*[self.searchScene setHidden:NO];
    [self.searchScene.backgroundView setAlpha:1.0];
    [self.searchScene.searchQueryBar setAlpha:1.0];
    [self.searchScene setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width,0)];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchScene setTransform:CGAffineTransformMakeTranslation(0,0)];
        [self.defaultScene setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width,0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];*/
}

- (void) searchToDirectionTransition {
    /*[UIView animateWithDuration:0.3 animations:^{
        [self.searchScene setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width,0)];
        [self.defaultScene setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchScene layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.searchScene setHidden:YES];
        }];
    }];*/
}

#pragma mark Content selection
- (void) hideSelectedContent {
    [self.defaultScene hideContent];
    [self.mapView removeMarkers];
    [self.mapView removePromotedPlaces];
}

- (void) showSelectedContent {
    [self.defaultScene showContent:self.selectedContent language:[self.mapView getLanguage] showInfoButton:YES];
    if ([self.selectedContent isKindOfClass:MWZPlace.class]) {
        [self.mapView addMarkerOnPlace:(MWZPlace*)self.selectedContent];
        [self.mapView addPromotedPlace:(MWZPlace*)self.selectedContent];
    }
    
}


- (void) unselectContent {
    [self.defaultScene hideContent];
    [self.mapView removeMarkers];
    [self.mapView removePromotedPlaces];
    self.selectedContent = nil;
}

- (void) selectPlace:(MWZPlace*) place {
    if (self.selectedContent) {
        [self.mapView removeMarkers];
        [self.mapView removePromotedPlaces];
    }
    [self.defaultScene showContent:place language:[self.mapView getLanguage] showInfoButton:YES];
    [self.mapView addMarkerOnPlace:place];
    [self.mapView addPromotedPlace:place];
    self.selectedContent = place;
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview {
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self selectPlace:place];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark MWZMapViewDelegate
- (void)mapView:(MWZMapView *_Nonnull)mapView didTap:(MWZClickEvent *_Nonnull)clickEvent {
    switch (clickEvent.eventType) {
        case MWZClickEventTypeVenueClick:
            [self.mapView centerOnVenuePreview:clickEvent.venuePreview animated:YES];
            break;
        case MWZClickEventTypePlaceClick:
            [self selectPlacePreview:clickEvent.placePreview];
            break;
        default:
            [self unselectContent];
            break;
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueWillEnter:(MWZVenue *_Nonnull)venue {
    [self fetchMainSearchesForVenues:venue];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidEnter:(MWZVenue *_Nonnull)venue {
    [self.defaultScene setSearchBarTitleForVenue:[venue titleForLanguage:[mapView getLanguage]]];
    [self.defaultScene setDirectionButtonHidden:NO];
    if (self.selectedContent) {
        [self showSelectedContent];
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidExit:(MWZVenue *_Nonnull)venue {
    [self.defaultScene setSearchBarTitleForVenue:@""];
    [self.defaultScene setDirectionButtonHidden:YES];
    self.mainSearches = @[];
    if (self.selectedContent) {
        [self hideSelectedContent];
    }
}

#pragma mark MWZDefaultSceneDelegate
- (void) didTapOnSearchButton {
    if ([self.mapView getVenue]) {
       [self.searchScene showSearchResults:self.mainSearches];
    }
    else {
        [self.searchScene showSearchResults:self.mainVenues];
    }
    [self mapToSearchTransition];
}

- (void) didTapOnMenuButton {
    
}

- (void) didTapOnDirectionButton {
    [self defaultToDirectionTransition];
}

#pragma mark MWZSearchSceneDelegate
- (void)didTapOnBackButton {
    [self searchToMapTransition];
}

- (void)searchQueryDidChange:(NSString *)query {
    // Default state
    if ([query length] == 0) {
        if ([self.mapView getVenue]) {
           [self.searchScene showSearchResults:self.mainSearches];
        }
        else {
            [self.searchScene showSearchResults:self.mainVenues];
        }
    }
    else {
        MWZSearchParams* params = [[MWZSearchParams alloc] init];
        params.query = query;
        params.venueIds = self.mapView.mapOptions.restrictContentToVenueIds;
        if ([self.mapView getVenue]) {
            params.venueId = [self.mapView getVenue].identifier;
            params.objectClass = @[@"place", @"placeList"];
        }
        else {
            params.objectClass = @[@"venue"];
        }
        [self.mapView.mapwizeApi searchWithSearchParams:params success:^(NSArray<id<MWZObject>> *searchResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchScene showSearchResults:searchResponse];
            });
        } failure:^(NSError *error) {
            
        }];
    }
    
    // Direction state from
    
    
    // Direction state to
}

- (void)didSelect:(id<MWZObject>)mapwizeObject {
    // Default state
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        [self.mapView centerOnPlace:(MWZPlace*)mapwizeObject animated:YES];
        [self selectPlace:(MWZPlace*)mapwizeObject];
    }
    if ([mapwizeObject isKindOfClass:MWZPlacelist.class]) {
        
    }
    if ([mapwizeObject isKindOfClass:MWZVenue.class]) {
        [self.mapView centerOnVenue:(MWZVenue*)mapwizeObject animated:YES];
    }
    [self searchToMapTransition];
    
    // Direction state from
    
    
    // Direction state to
}

#pragma mark MWZDirectionSceneDelegate
- (void)directionSceneDidTapOnBackButton:(MWZDirectionScene *)scene {
    [self directionToDefaultTransition];
}

@end
