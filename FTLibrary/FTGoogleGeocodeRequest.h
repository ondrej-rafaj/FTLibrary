//
//  FTGoogleGeocodeRequest.h
//  FTLibrary
//
//  Created by Francesco on 15/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTGooglePlaceRequest.h"


@interface FTGoogleGeocodeRequest : NSObject {
    FTGooglePlaceRequestOutput output;
    CLLocationCoordinate2D location;
    NSString *address;
    NSString *language;
    NSString *region;
    BOOL sensor;

}

@property (nonatomic, assign) FTGooglePlaceRequestOutput output;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, assign, getter=isSensor) BOOL sensor;

- (NSURL *)urlForRequest;
- (NSString *)urlStringForRequest;

@end
