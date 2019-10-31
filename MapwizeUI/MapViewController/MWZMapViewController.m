#import "MWZMapViewController.h"
#import "MWZUIConstants.h"
#import "MWZSearchScene.h"
#import "MWZDefaultScene.h"

@interface MWZMapViewController ()

@property (nonatomic) MWZSceneCoordinator* sceneCoordinator;
@property (nonatomic) MWZSearchScene* searchScene;
@property (nonatomic) MWZDefaultScene* defaultScene;

@property (nonatomic) NSArray<MWZVenue*>* mainVenues;
@property (nonatomic) NSArray<id<MWZObject>>* mainSearches;

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
- (void) selectPlace:(MWZPlace*) place {
    [self.defaultScene showContentWithPlace:place language: [self.mapView getLanguage] showInfoButton:YES];
}

- (void) selectPlacePreview:(MWZPlacePreview*) placePreview {
    [placePreview getFullObjectAsyncWithSuccess:^(MWZPlace * _Nonnull place) {
        [self.defaultScene showContentWithPlace:place language: [self.mapView getLanguage] showInfoButton:YES];
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
            break;
    }
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueWillEnter:(MWZVenue *_Nonnull)venue {
    [self fetchMainSearchesForVenues:venue];
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidEnter:(MWZVenue *_Nonnull)venue {
    
}

- (void)mapView:(MWZMapView *_Nonnull)mapView venueDidExit:(MWZVenue *_Nonnull)venue {
    self.mainSearches = @[];
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
    [self directionToSearchTransition];
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

@end
