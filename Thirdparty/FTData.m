//
//  FTData.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTData.h"
#import "FTError.h"


@implementation FTData

+ (NSData *)dataWithContentsOfUrl:(NSString *)url {
	return [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

+ (NSString *)stringWithContentsOfUrl:(NSString *)url {
	NSError *error;
	NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		[FTError handleError:error];
	}
	return string;
}

+ (BOOL)isEmpty:(NSString *)string {
	if (!string) return NO;
	return (BOOL)[string length];
}

+ (void)cacheValue:(id)object WithKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)cachedValueForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}


@end
