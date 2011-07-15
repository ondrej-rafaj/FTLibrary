//
//  FTGooglePlaceRequest.h
//  FTLibrary
//
//  Created by Francesco on 15/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    FTGooglePlaceRequestOutputJSON,
    FTGooglePlaceRequestOutputXML
}FTGooglePlaceRequestOutput;

@interface FTGooglePlaceRequest : NSObject {
    CLLocationCoordinate2D location;
    FTGooglePlaceRequestOutput output;
    NSInteger radius;
    NSArray *types;
    NSString *language;
    NSString *name;
    BOOL sensor;
    NSString *APIKey;
}

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) FTGooglePlaceRequestOutput output;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign, getter=isSensor) BOOL sensor;
@property (nonatomic, retain) NSString *APIKey;

- (NSURL *)urlForRequest;
- (NSString *)urlStringForRequest;

@end

@interface FTGooglePlaceResult : NSObject {
    
    //generic result layer
    NSString *name;
    NSString *vicinity;
    NSArray *types;
    CLLocationCoordinate2D location;
    NSURL *iconURL;
    NSString *reference;
    NSString *placeID;
    
    //detailed result layer
    NSString *telephone;
    NSString *address;
    float rating;
    NSURL *url;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *vicinity;
@property (nonatomic, retain) NSArray *types;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSURL *iconURL;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSString *placeID;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) float rating;
@property (nonatomic, retain) NSURL *url;

- (id)initWithDictionaryResult:(NSDictionary *)dictionary;
- (BOOL)hasModeDetails;

@end
