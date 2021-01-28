# Mapwize UI iOS Changelog

## 2.2.5

- Upgrading the Mapwize SDK to 3.3.1
  - Adding missing 'placeTypeId' in serialized place

## 2.2.4

- Add scroll in search results
- Add delete button in search textfield

## 2.2.3

- Upgrading the Mapwize SDK to 3.3.0
  - Deprecating the following methods, classes and attributes:
      - Methods:
          - MapView: Add markers methods
          - MapView: Add promoted place methods
          - MapViewDelegate: didTapOnMarker
      - Attributes: 
          - DisplayEndMarker and endMarkerIcon in MWZDirectionOptions
      - Class: 
          MWZMapwizeAnnotation
  - Adding marker to the map is now done using addMarkers:(MWZMarker*) methods:
      - A marker can be created from MWZMarkerOptions allowing more customization.
      
  - Adding select place methods:
      - Selecting a place highlights it and gives it more visibility. This behavior replaces the promote.
      
  - Adding marker and line options in MWZDirectionOptions to allow more customization on the direction drawing process.
  - Adding missing direction mode icon.

## 2.2.2

- Fixing FloorController scroll to visible floor
- Removing vertical scroll indicator on FloorController

## 2.2.1

- Updating Mapwize SDK to 3.2.1
- Adding translation for Dutch, French and German
- Adding loading indicator when retrieving place info

## 2.2.0

- Integrating Mapwize SDK 3.1.0
- Introducting direction modes to allow computation of optimized directions for different profiles. This feature extends the existing accessibility feature in the directions.
	- The modes configured in Mapwize Studio for each venue / universe will automatically appear in the direction interface.
	- The method `setDirection` has been changed to accept a mode instead of the `isAccessible` option.

## 2.1.7

- Fixing warnings
- Update documentation

## 2.1.6

- Adding all MapwizeSDK delegate methods in the MapwizeUI delegate
- Adding events to the delegate for analytics purpose
- Adding direction start event
- Adding language change event
- Changing mapwizeMap to mapView in the doc
- Hidding other universes in direction search
- Hidding "no result" if there is no query
- Fixing crash when clicking on "no result"
- Fixing isMenuHidden option

## 2.1.5

- Adding missing that can produce compilation error 

## 2.1.4

- Hidding informationButton by default

## 2.1.3

- Centering on placelist when selectPlacelist is called

## 2.1.2

- Adding missing argument centerOn is selectPlace method

## 2.1.1

- Fixing missing main color after initialization

## 2.1.0

- Prefixing all classes with MWZUI. MWZMapwizeView becomes MWZUIView.
- Improving UI Behavior.
- Fixing issue with animation that created unexpected behaviour.
- Removing mainColor from UISettings. Use MWZUIOptions instead.

## 2.0.4

- Updating MapwizeSDK to 3.0.11

## 2.0.3

- Updating MapwizeSDK to 3.0.10

## 2.0.2

- Updating MapwizeSDK to 3.0.6

## 2.0.1

- Updating MapwizeSDK to 3.0.1

## 2.0.0

- Changing dependency from MapwizeForMapbox to MapwizeSDK
- Improving direction search module

## 1.2.1

- Fixing issue when canceling enter in venue

## 1.2.0

- Fixing issue with selected placelist

## 1.1.0

- Adding support for MapwizeForMapbox 2.0.0
- Adding details in bottom view if the selected content has details to display
- Adding subtitle in search result
- Using navigation instead of direction if the user start from its current position
- Fixing loading bar display
- Displaying loading bar when searching for a direction
- Improving design

## 1.0.3

- Adding delegate method to handle universe change
- Adding delegate method to show or hide the floor controller depends of the current floors list

## 1.0.2

- Fixing issue with languages button

## 1.0.1

- Adding missing resources

## 1.0.0

- Publishing the first version of Mapwize UI
