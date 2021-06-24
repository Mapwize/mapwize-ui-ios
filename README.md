# Mapwize UI iOS

[![pipeline status](https://gitlab.com/mapwize/mapwize-ui-ios-mirror/badges/master/pipeline.svg)](https://gitlab.com/mapwize/mapwize-ui-ios-mirror/-/commits/master)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/mapwize/mapwize-ui-ios)
![Cocoapods](https://img.shields.io/cocoapods/v/MapwizeUI)

Fully featured and ready to use UIView to add Mapwize Indoor Maps and Navigation in your iOS app.

And it's open-source !

For documentation about Mapwize SDK objects like MWZVenue, MWZPlace, MWZOptions... Please refer to the Mapwize SDK documentation on [docs.mapwize.io](https://docs.mapwize.io).

## Description

The Mapwize UI view comes with the following components:

- Mapwize SDK integration
- Floor controller
- Follow user button
- Search module
- Direction module
- Place selection
- Universes button
- Languages button

## Installation

MapwizeUI is compatible with MapwizeForMapbox 3.0.0 and above. The library won't work with lower version.

### Cocoapod

Add the MapwizeUI library to your Podfile 

```
pod 'MapwizeUI', '~> 2.0'
```

Then run a `pod install`

All dependencies will be installed (MapwizeUI, MapwizeForMapbox, Mapbox and IndoorLocation)


### Manual

- Clone the Github repository
- Copy the MapwizeUI project into your app project

## Initialization

### API Key

You'll need a Mapwize API key to load the map and allow API requests. Simply add MWZApiKey with the key in your info.plist.

To get your own Mapwize API key, sign up for a free account at mapwize.io. Then within the Mapwize Studio, navigate to "API Keys" on the side menu.

### Mapbox configuration

The Mapwize iOS SDK is built on top of [Mapbox GL native for iOS](https://github.com/mapbox/mapbox-gl-native).

The Mapbox map is used as base map to display the outdoor. It is an amazingly powerful SDK allowing you to do a lot of cool stuff with the map. If you want to move the map, rotate it, overlay your own data or more, you can do it directly by controlling the Mapbox map. Adding Mapwize does not remove any capability from Mapbox, it just adds more. Have a look at the [Mapbox documentation](https://www.mapbox.com/ios-sdk/) to see all features.

With the Mapwize SDK, we are extending Mapbox adding the possibility of getting inside buildings. As you zoom on the map, you will automatically enter in buildings, see the different floors and be able to navigate inside. If you want to change floors, see different universes (views) of the building, draw directions inside or display the user's indoor location, then you'll interact with the Mapwize plugin.

### Configuring the outdoor map

Mapwize SDK is using the Mapbox SDK to render the outdoor map. There are 2 options regarding the outdoor:

- You can make use of the default Mapwize outdoor map. This comes free of charge with your Mapwize subscription but does not let you make any modification to the style or data. This comes by default. Attributions are shown to aknowledge the origin and copyright of the data.
- You can use the full power of Mapbox to create your own outdoor map style and customize it precisely the way you want. This requires you to have a Mapbox subcription and set your Mapbox access token. To use your own Mapbox style within your Mapwize View, set `styleUrl` in your MWZMapwizeConfiguration.

### MWZMapwizeView

The UIView that embeds the MWZMapwizeView must implement `MWZMapwizeViewDelegate` with the followings methods :

```objective-c
- (void) mapwizeViewDidLoad:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceListInformationButton:(MWZPlaceList*) placeList; --> why not (id<MWZObject>) mapwizeObject
- (void) mapwizeViewDidTapOnFollowWithoutLocation:(MWZMapwizeView*) mapwizeView;
- (void) mapwizeViewDidTapOnMenu:(MWZMapwizeView*) mapwizeView;
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
```

MWZMapwizeView can be instantiated with the constructor :

```objective-c
- (instancetype) initWithFrame:(CGRect)frame
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;

- (instancetype) initWithFrame:(CGRect)frame
          mapwizeConfiguration:(MWZMapwizeConfiguration*) mapwizeConfiguration
                mapwizeOptions:(MWZUIOptions*) options
                    uiSettings:(MWZMapwizeViewUISettings*) uiSettings;
```

MWZMapwizeViewUISettings contains the following attribute

```objective-c
@property (nonatomic, retain) UIColor* mainColor;
@property (nonatomic, assign) BOOL menuButtonIsHidden;
@property (nonatomic, assign) BOOL followUserButtonIsHidden;
```

### Access to MWZMapView

Once the `(void) mapwizeViewDidLoad:(MWZMapwizeView*) mapwizeView` is called, you can retrieved the MWZMapView using `mapwizeView.mapView`

```objective-c
@property (nonatomic) MWZMapView* mapView;
```

### Simple example

```objective-c
MWZOptions* opts = [[MWZOptions alloc] init];
MWZUISettings* settings = [[MWZUISettings alloc] init];
self.mapwizeView = [[MWZMapwizeView alloc] initWithFrame:self.view.frame
                                          mapwizeOptions:opts
                                              uiSettings:settings];
self.mapwizeView.delegate = self;
[self.view addSubview:self.mapwizeView];
```

### Center on venue

To have the map centered on a venue at start up:

```objective-c
MWZOptions* opts = [[MWZOptions alloc] init];
opts.centerOnVenueId = @"YOUR_VENUE_ID";
MWZUISettings* settings = [[MWZUISettings alloc] init];
self.mapwizeView = [[MWZMapwizeView alloc] initWithFrame:self.view.frame
                                          mapwizeOptions:opts
                                              uiSettings:settings];
```

### Center on place

To have the map centered on a place with the place selected: 

```objective-c
MWZOptions* opts = [[MWZOptions alloc] init];
opts.centerOnPlaceId = @"YOUR_PLACE_ID";
MWZUISettings* settings = [[MWZUISettings alloc] init];
self.mapwizeView = [[MWZMapwizeView alloc] initWithFrame:self.view.frame
                                          mapwizeOptions:opts
                                              uiSettings:settings];
```

### Map options

The following parameters are available for map initialization:

- `centerOnVenueId` to center on a venue at start. 
- `centerOnPlaceId` to center on a place at start. 
- `floor` to set the default floor when entering a venue. Floors are Double and can be decimal values. This is ignored when using centerOnPlace.
- `language` to set the default language for venues. It is a string with the 2 letter code for the language. Example: "fr" or "en".
- `universeId` to set the default universe for the displayed venue. If using centerOnPlace, this needs to be an universe the place is in.
- `restrictContentToVenueId` to show only the related venue on the map. 
- `restrictContentToVenueIds` to show only the specified venues on the map. 
- `restrictContentToOrganizationId` to show only the venues of that organization on the map. 

### Public methods

Friendly method to add new access to the map and refresh the UI
`- (void) grantAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;`

Setup the UI to display information about the selected place
Promote the place and add a marker on it
`- (void) selectPlace:(MWZPlace*) place centerOn:(BOOL) centerOn;`

Setup the UI to display information about the selected placelist
Add markers on places contained in the placelist and promote them
`- (void) selectPlaceList:(MWZPlaceList*) placeList;`

Hide the UI component, remove markers and unpromote place if needed
`- (void) unselectContent:(BOOL) closeInfo;`

Display a direction object and show the direction UI already configured
```objective-c 
- (void) setDirection:(MWZDirection*) direction
                 from:(id<MWZDirectionPoint>) from
                   to:(id<MWZDirectionPoint>) to
        directionMode:(MWZDirectionMode*) directionMode
```

## Place details

Place details provides you with a ready to use, yet customizable UI.
You can have a full control over the displayed buttons and rows.

You can use the following callback to control the Buttons and the Rows of the Details UI.

```objective-c
/**
 Called when the bottom view is going to be displayed
 The MapwizeUI SDK build all component that will be displayed in the view and give it back to the developper through this method's components argument.
 You can change, remove or add component in the MWZUIBottomSheetComponents and return it.
 The returned MWZUIBottomSheetComponents will be used to display the final content.
 @param mapwizeView the view that called the methode
 @param placeDetails the placeDetails object about to be displayed in the bottom view
 @param components the components build by the SDK based on the info contains in the object.
 */
- (MWZUIBottomSheetComponents* _Nonnull) mapwizeView:(MWZUIView* _Nonnull) mapwizeView requireComponentForPlaceDetails:(MWZPlaceDetails* _Nonnull)placeDetails withDefaultComponents:(MWZUIBottomSheetComponents* _Nonnull)components;
```

You will receive a list of Buttons, you can modify them, change their order or remove some of them.


The `shouldDisplayInformationButton` callback is called before the `requireComponentForPlaceDetails`.
The `requireComponentForPlaceDetails` callback will have the last word on the display of the Rows or Buttons.

### Managing Buttons

You can create a Small Button object using the `MWZUIIconTextButton` constructor `- (instancetype)initWithTitle:(NSString*) title image:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined;`

You can create a Big Button object using the `MWZUIFullContentViewComponentButton` constructor `- (instancetype)initWithTitle:(NSString*) title image:(UIImage*) image color:(UIColor*) color outlined:(BOOL) outlined;`

### Managing Rows
You can create a Row object using: `MWZUIFullContentViewComponentRow` constructor `- (instancetype) initWithImage:(UIImage*)image contentView:(UIView*)contentView color:(UIColor*)color tapGestureRecognizer:(nullable UITapGestureRecognizer*)tapGestureRecognizer type:(MWZUIFullContentViewComponentRowType)type infoAvailable:(BOOL) infoAvailable`

## Information button

When users select a Place or a PlaceList, either by clicking on the map or using the search engine, you might want to give the possibility to the user to open a page of your app about it. Think about shops or exhibitors for example for which your app probably has a page with all the details about.

The proposed solution is to display an "information" button on the bottom view in the Mapwize View.

You can use the delegate method `shouldShowInformationButtonFor` to say if the button should be displayed or not. Return true to display the button for the given Mapwize object.

```objective-c
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowInformationButtonFor:(id<MWZObject>) mapwizeObject;
```

Example to display the information button only for Places and not for PlaceLists:

```objective-c
- (BOOL) mapwizeView:(MWZMapwizeView *)mapwizeView shouldShowInformationButtonFor:(id<MWZObject>)mapwizeObject {
    if ([mapwizeObject isKindOfClass:MWZPlace.class]) {
        return YES;
    }
    return NO;
}
```

The same kind of methods are available to display or hide the floor controller depends of the floors list and to listen universe change event :

```objective-c
- (BOOL) mapwizeView:(MWZMapwizeView*) mapwizeView shouldShowFloorControllerFor:(NSArray<MWZFloor*>*) floors;
- (void) mapwizeUniverseHasChanged:(MWZUniverse*)universe; __attribute__((deprecated("Use MWZMapViewDelegate instead")));
```

When the information button is clicked, the delegate call one of the following methods with the selected Mapwize object.

```objective-c
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceInformationButton:(MWZPlace*) place;
- (void) mapwizeView:(MWZMapwizeView*) mapwizeView didTapOnPlaceListInformationButton:(MWZPlaceList*) placeList;
```

## Colors 

You can change the color of the colored UI view by using the UISettings.mainColor attribute.

## Translations

The view contains some strings that you may want to translate or change.
You can override them in your `strings.xml` file and add other Localizable.strings file in order to support different languages

```
"Direction" = "Direction";
"Information" = "Information";
"Search a venue..." = "Search a venue...";
"Entering in %@..." = "Entering in %@...";
"Search in %@..." = "Search in %@...";
"Destination" = "Destination";
"Starting point" = "Starting point";
"Current location" = "Current location";
"No results" = "No results";
"Floor %@" = "Floor %@";
"Universes" = "Universes";
"Choose an universe to display it on the map" = "Choose a universe to display it on the map";
"Languages" = "Languages";
"Choose your preferred language" = "Choose your preferred language";
"Cancel" = "Cancel";
"Direction not found" = "Direction not found"
"Search error" = "Search went wrong"
"Search" = "Search"
```

Be careful with strings containing placeholders. Please ensure that the exact placeholders are kept!
For example, if you replace "Floor %@" with "My floor" without placeholder, your application will crash.

## Demo application

A demo application is available in this repository to quickly test the UI. 
The only thing you need to get started is a Mapwize api key. 
You can get your key by signing up for a free account at [mapwize.io](https://www.mapwize.io).

Once you have your API key, add it to the info.plist with the key MWZMapwizeApiKey

To test the UI further, go to ViewController and change some options or add some code in it.

## Analytics

Mapwize SDK and Mapwize UI do __not__ have analytics trackers built in. This means that Mapwize does not know how maps are used in your applications, which we believe is a good thing for privacy. This also means that Mapwize is not able to provide you with analytics metrics and that, if you want any, you will have to intrument your code with your own analytics tracker.

Events and callbacks from `MWZUIViewDelegate` can be used to detect changes in the interface and trigger tracking events. We believe using the following events would make sense:

- `venueDidEnter` 
- `venueDidExit`
- `floorDidChange`
- `universeDidChange`
- `languageDidChange`
- `didSelectPlace`
- `didSelectPlacelist`
- `didStartDirectionInVenue`
