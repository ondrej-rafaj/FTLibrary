//
//  FTGooglePlaceRequest.m
//  FTLibrary
//
//  Created by Francesco on 15/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTGooglePlaceRequest.h"


@implementation FTGooglePlaceRequest

@synthesize location;
@synthesize output;
@synthesize radius;
@synthesize types;
@synthesize language;
@synthesize name;
@synthesize sensor;
@synthesize APIKey;
@synthesize reference;


- (id)init {
    self = [super init];
    if (self) {
        types = [[NSArray alloc] init];
        language = [[NSString alloc] initWithString:@"en"];
        name = [[NSString alloc] init];
        APIKey = [[NSString alloc] init];
        reference = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc {    
    [types release];
    [language release];
    [name release];
    [APIKey release];
    [reference release];
    [super dealloc];
}



- (NSURL *)urlForRequest {
    return [NSURL URLWithString:[self urlStringForRequest]];
}


- (NSString *)urlStringForRequest; {
    if ((location.latitude == 0.0 && location.longitude == 0.0) || !radius || [APIKey isEqualToString:@""]) {
        [NSException raise:@"some of the required fields are nil" format:@"location %.2f,%.2f | radius %d | API Key %@ ", output, location.latitude, location.longitude, radius, APIKey];
    }
    NSMutableString *components = [NSMutableString string];
    [components appendFormat:@"?location=%f,%f",location.latitude, location.longitude];
    [components appendFormat:@"&radius=%d", radius];
    [components appendFormat:@"&language=%@", language];
    if (![name isEqualToString:@""]) {
        [components appendFormat:@"&name=%@", name];
    }
    [components appendFormat:@"&sensor=%@", (sensor)? @"true" : @"false"];
    [components appendFormat:@"&key=%@", APIKey];
    
    if (types && [types count] > 0) {
        [components appendFormat:@"&types=%@", [types componentsJoinedByString:@"%7C"]];
    }
    
    NSString *format = (output == FTGooglePlaceRequestOutputJSON)? @"json" : @"xml";
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/%@%@", format, components];
    return urlString;
}

- (NSURL *)urlForFurtherData {
    return [NSURL URLWithString:[self urlStringForFurtherData]];
}

- (NSString *)urlStringForFurtherData {
    if ([reference isEqualToString:@""] || [APIKey isEqualToString:@""]) {
        [NSException raise:@"Some data are empty is empty" format:@"Reference or APIKey are empty"];
    }
    NSMutableString *components = [NSMutableString string];
    [components appendFormat:@"?reference=%@", reference];
    [components appendFormat:@"&language=%@", language];
    [components appendFormat:@"&sensor=%@", (sensor)? @"true" : @"false"];
    [components appendFormat:@"&key=%@", APIKey];
    
    NSString *format = (output == FTGooglePlaceRequestOutputJSON)? @"json" : @"xml";
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/%@%@", format, components];
    return urlString;

}

@end

@implementation FTGooglePlaceResult

@synthesize name;
@synthesize vicinity;
@synthesize types;
@synthesize location;
@synthesize iconURL;
@synthesize reference;
@synthesize placeID;
@synthesize telephone;
@synthesize address;
@synthesize rating;
@synthesize url;

- (void)dealloc {
    
    [name release];
    [vicinity release];
    [types release];
    [iconURL release];
    [reference release];
    [placeID release];
    [telephone release];
    [address release];
    [url release];
    [super dealloc];
}


- (id)initWithDictionaryResult:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self && dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        NSDictionary *position_ = [[dictionary objectForKey:@"geometry"] objectForKey:@"location"];
        CLLocationCoordinate2D loc =  CLLocationCoordinate2DMake([[position_ objectForKey:@"lat"] floatValue], [[position_ objectForKey:@"lng"] floatValue]);
        [self setLocation:loc];
        
        [self setName:(NSString *)[dictionary objectForKey:@"name"]];
        
        [self setVicinity:(NSString *)[dictionary objectForKey:@"vicinity"]];
        
        [self setTypes:(NSArray *)[dictionary objectForKey:@"types"]];
        
        [self setIconURL:[NSURL URLWithString:(NSString *)[dictionary objectForKey:@"icon"]]];
        
        [self setReference:(NSString *)[dictionary objectForKey:@"reference"]];
        
        [self setPlaceID:(NSString *)[dictionary objectForKey:@"id"]];
        
        [self setTelephone:(NSString *)[dictionary objectForKey:@"formatted_phone_number"]];
        
        [self setAddress:(NSString *)[dictionary objectForKey:@"formatted_address"]];
        
        [self setUrl:[NSURL URLWithString:(NSString *)[dictionary objectForKey:@"url"]]];       
    }
    
    return  self;
    
}

- (BOOL)hasModeDetails {
    return (address && ![address isEqualToString:@""]);
}

@end
