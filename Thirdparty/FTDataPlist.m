//
//  FTDataPlist.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDataPlist.h"
#import "FTError.h"


@implementation FTDataPlist

+ (NSDictionary *)plistDictionaryFromString:(NSString *)string {
	abort();
}

+ (NSDictionary *)plistDictionaryFromUrl:(NSString *)url {
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:url]];
	if (!d) [FTError handleErrorWithString:[NSString stringWithFormat:@"Corrupted remote dictionary plist file (%@)", url]];
	return d;
}

+ (NSArray *)plistArrayFromString:(NSString *)string {
	abort();
}

+ (NSArray *)plistArrayFromUrl:(NSString *)url {
	NSArray *arr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
	if (!arr) [FTError handleErrorWithString:[NSString stringWithFormat:@"Corrupted remote array plist file (%@)", url]];
	return arr;
}


@end
