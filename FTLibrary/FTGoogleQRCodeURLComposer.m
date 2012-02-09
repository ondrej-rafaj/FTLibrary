//
//  FTGoogleQRCodeURLComposer.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTGoogleQRCodeURLComposer.h"


@implementation FTGoogleQRCodeURLComposer

@synthesize size = _size;
@synthesize type = _type;
@synthesize image = _image;


#pragma mark Getters

- (NSString *)getUrlString {
	return @"";
}

- (NSURL *)getUrl {
	return [NSURL URLWithString:[self getUrlString]];
}

#pragma mark Memory management

- (void)dealloc {
	[_image release];
	[super dealloc];
}


@end
