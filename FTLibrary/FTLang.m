//
//  FTLang.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLang.h"
#import "FTProject.h"
#import "FTData.h"


static NSDictionary *translations;
static NSString *updateUrl;


@implementation FTLang

#pragma mark Update process

- (void)downloadLanguage:(FTLang *)lang {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@synchronized(self) {
		NSError *error = nil;
		NSString *string = [FTData stringWithContentsOfUrl:updateUrl];
		if (error) [FTError handleError:error];
		else {
			
		}
	}
	[lang release];
	[pool drain];
}

- (void)startBackgroundDownloading:(FTLang *)lang {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorInBackground:@selector(downloadLanguage:) withObject:lang];
	[pool drain];
}

#pragma mark Static settings methods

+ (NSDictionary *)translations {
	return translations;
}

+ (NSString *)get:(NSString *)key {
	NSDictionary *t = [self translations];
	if (t) {
		NSString *ret = [t objectForKey:key];
		if (!ret) {
			if ([FTProject debugging]) {
				[FTError handleErrorWithString:[NSString stringWithFormat:@"No translation for key: %@", key]];
			}
		}
		return ret;
	}
	return NSLocalizedString(key, key);
}

+ (void)prepareWithUrl:(NSString *)url {
	updateUrl = url;
	[updateUrl retain];
	[self update];
}

+ (NSInteger)currentLangVersion {
	return 0;
}

+ (void)update {
	FTLang *lng = [[FTLang alloc] init];
	[NSThread detachNewThreadSelector:@selector(startBackgroundDownloading:) toTarget:lng withObject:lng];
}


@end
