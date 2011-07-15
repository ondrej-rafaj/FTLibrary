//
//  FTGoogleGeocodeRequest.m
//  FTLibrary
//
//  Created by Francesco on 15/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTGoogleGeocodeRequest.h"


@implementation FTGoogleGeocodeRequest

@synthesize output;
@synthesize location;
@synthesize address;
@synthesize language;
@synthesize region;
@synthesize sensor;



- (id)init {
    self = [super init];
    if (self) {
        location = CLLocationCoordinate2DMake(0.0, 0.0);
        language = [[NSString alloc] initWithString:@"en"];
        address = [[NSString alloc] init];
        region = [[NSString alloc] initWithString:@"uk"];
    }
    return self;
}

- (void)dealloc {
    [language release];
    [address release];
    [region release];
    [super dealloc];
}


- (NSURL *)urlForRequest {
    return [NSURL URLWithString:[self urlStringForRequest]];
}


- (NSString *)urlStringForRequest {
    if ((location.latitude == 0.0 && location.longitude == 0.0) && [address isEqualToString:@""]) {
        [NSException raise:@"some of the required fields are nil" format:@"some of the required fields are nil"];
    }
    NSMutableString *components = [NSMutableString string];
    
    [components appendFormat:@"?language=%@", language];
    if (!(location.latitude == 0.0 && location.longitude == 0.0)) {
        [components appendFormat:@"&location=%f,%f",location.latitude, location.longitude];
    }
    if (![address isEqualToString:@""]) {
        [components appendFormat:@"&address=%@", address];
    }
    [components appendFormat:@"&region=%@", region];

    [components appendFormat:@"&sensor=%@", (sensor)? @"true" : @"false"];
    
    NSString *format = (output == FTGooglePlaceRequestOutputJSON)? @"json" : @"xml";
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/%@%@", format, components];
    return urlString;
}


@end
