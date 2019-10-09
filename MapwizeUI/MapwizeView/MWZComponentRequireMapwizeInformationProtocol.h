#ifndef MWZComponentRequireMapwizeInformationProtocol_h
#define MWZComponentRequireMapwizeInformationProtocol_h

@class MWZVenue;
@class MWZUniverse;
@class ILIndoorLocation;

@protocol MWZComponentRequireMapwizeInformationProtocol <NSObject>

- (MWZVenue*) componentRequiresCurrentVenue:(id) component;
- (NSString*) componentRequiresCurrentLanguage:(id) component;
- (MWZUniverse*) componentRequiresCurrentUniverse:(id) component;
- (ILIndoorLocation*) componentRequiresUserLocation:(id) component;

@end

#endif
