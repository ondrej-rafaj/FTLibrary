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

+ (NSString *)stringWithContentsOfUrl:(NSString *)urlString {
	NSError *error = nil;
    NSURLResponse *response;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:5];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
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
