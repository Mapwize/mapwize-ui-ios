//
//  MWZUIPlaceMock.m
//  BottomSheet
//
//  Created by Etienne on 28/09/2020.
//

#import "MWZUIPlaceMock.h"

@implementation MWZUIPlaceMock

+ (instancetype) getMock1 {
    MWZUIPlaceMock* mock = [MWZUIPlaceMock new];
    mock.title = @"Mapwize";
    mock.subtitle = @"Indoor Mapping Platform. One of the best, probably the best. We like to make great maps and we like to make money";
    mock.details = @"";
    mock.floorName = @"3";
    mock.imageUrls = @[@"https://upload.wikimedia.org/wikipedia/commons/8/8e/Euratechnologies_batiment_le_blanc_lafont_lille_incubateur_startup.jpg",
                       @"https://en.euratechnologies.com/wp-content/webp-express/webp-images/doc-root/wp-content/uploads/2020/01/euratechnologies-ecosysteme-tech-1173x818-1-652x473.png.webp",
                       @"https://cap.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcap.2F2018.2F03.2F01.2F7697ac0b-df76-41f9-bbe7-5beba597e204.2Ejpeg/750x375/background-color/ffffff/quality/70/euratech-lincubateur-lillois-qui-monte-qui-monte-1275424.jpg"];
    mock.iconUrl = @"";
    mock.phoneNumber = @"03.59.08.32.30";
    mock.email = @"etienne@mapwize.io";
    mock.calendarEvents = @[@{@"startTime": @13.0, @"endTime": @14.0, @"title":@"Get the new car"},
                            @{@"startTime": @8.0, @"endTime": @9.3, @"title":@"Think about calendar event"},
                            @{@"startTime": @16.0, @"endTime": @17.0, @"title":@"Share result with Lakhdar"}];
    mock.website = @"https://www.mapwize.io";
    mock.sharable = YES;
    mock.openingHours = @[@"", @"", @""];
    return mock;
}

+ (instancetype) getMock2 {
    MWZUIPlaceMock* mock = [MWZUIPlaceMock new];
    mock.title = @"Cisco";
    mock.subtitle = @"Try to make an inernet router";
    mock.details = @"";
    mock.floorName = @"3";
    mock.imageUrls = @[@"https://upload.wikimedia.org/wikipedia/commons/8/8e/Euratechnologies_batiment_le_blanc_lafont_lille_incubateur_startup.jpg",
                       @"https://en.euratechnologies.com/wp-content/webp-express/webp-images/doc-root/wp-content/uploads/2020/01/euratechnologies-ecosysteme-tech-1173x818-1-652x473.png.webp",
                       @"https://cap.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcap.2F2018.2F03.2F01.2F7697ac0b-df76-41f9-bbe7-5beba597e204.2Ejpeg/750x375/background-color/ffffff/quality/70/euratech-lincubateur-lillois-qui-monte-qui-monte-1275424.jpg"];
    mock.iconUrl = @"";
    
    return mock;
}

@end
