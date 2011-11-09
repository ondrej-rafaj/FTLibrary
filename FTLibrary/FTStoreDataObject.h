//
//  FTStoreDataObject.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTStoreDataObject : NSObject {
	
	NSString *title;
	NSString *description;
	NSNumber *price;
	NSNumber *identifier;
	NSString *filename;
	NSString *downloadUrl;
	NSString *imageLUrl;
	NSString *imageMUrl;
	NSString *imageSUrl;
	
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *downloadUrl;
@property (nonatomic, retain) NSString *imageLUrl;
@property (nonatomic, retain) NSString *imageMUrl;
@property (nonatomic, retain) NSString *imageSUrl;

+ (FTStoreDataObject *)objectWithDictionary:(NSDictionary *)dictionary;


@end
