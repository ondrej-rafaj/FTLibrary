//
//  KeyValuePairReader.m
//  FTLibrary
//
//  Created by Simon Lee on 21/07/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "NSDictionary+KeyValuePair.h"


@implementation NSDictionary (KeyValuePair)

+ (NSDictionary *)dictionaryFromKeyValuePairUrl:(NSString *)url {
	NSError *error = nil;
	
	NSString *contents = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
	NSString *formatted = [contents stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	[contents release];
	
	NSArray *lines = [formatted componentsSeparatedByString:@"\n"];
	
	NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
	NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
	
	for(NSString *line in lines) {
		NSArray *value = [line componentsSeparatedByString:@"="];
		[keys addObject:[value objectAtIndex:0]];
		[objects addObject:[value objectAtIndex:1]];
	}
	
	NSDictionary *result = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	[keys release];
	[objects release];
	
	return result;
}

@end
