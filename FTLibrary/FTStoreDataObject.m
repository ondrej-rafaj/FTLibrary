//
//  FTStoreDataObject.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreDataObject.h"

@implementation FTStoreDataObject

@synthesize title;
@synthesize description;
@synthesize price;
@synthesize identifier;
@synthesize filename;
@synthesize downloadUrl;
@synthesize imageLUrl;
@synthesize imageMUrl;
@synthesize imageSUrl;


#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
//		self.title = @"Esquire, June 2010";
//		self.description = @"How to be a man, lorem ipsum dolor sit amet.";
//		self.price = [NSNumber numberWithFloat:3.99];
//		self.identifier = [NSNumber numberWithInt:9876];
//		self.filename = @"Esquire-June.pdf";
//		self.downloadUrl = [NSString stringWithFormat:@"http://www.stickertagapp.com/magazineApp/%@", self.filename];
//		self.imageLUrl = @"http://www.stickertagapp.com/magazineApp/Esquire-June-cover-l.jpg";
//		self.imageMUrl = @"http://www.stickertagapp.com/magazineApp/Esquire-June-cover-m.jpg";
//		self.imageSUrl = @"http://www.stickertagapp.com/magazineApp/Esquire-June-cover-s.jpg";
	}
	return self;
}

+ (FTStoreDataObject *)objectWithDictionary:(NSDictionary *)dictionary {
	FTStoreDataObject *o = [[FTStoreDataObject alloc] init];
	[o setTitle:[dictionary objectForKey:@"title"]];
	[o setDescription:[dictionary objectForKey:@"description"]];
	[o setPrice:[dictionary objectForKey:@"price"]];
	[o setIdentifier:[dictionary objectForKey:@"identifier"]];
	[o setFilename:[dictionary objectForKey:@"filename"]];
	[o setDownloadUrl:[dictionary objectForKey:@"downloadUrl"]];
	[o setImageLUrl:[dictionary objectForKey:@"imageLUrl"]];
	[o setImageMUrl:[dictionary objectForKey:@"imageMUrl"]];
	[o setImageSUrl:[dictionary objectForKey:@"imageSUrl"]];
	return [o autorelease];
}

#pragma mark Memory managemnt

- (void)dealloc {
	[title release];
	[description release];
	[price release];
	[identifier release];
	[filename release];
	[downloadUrl release];
	[imageLUrl release];
	[imageMUrl release];
	[imageSUrl release];
	[super dealloc];
}


@end
