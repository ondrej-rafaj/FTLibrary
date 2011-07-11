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
#import "FTDataJson.h"
#import "FTFilesystem.h"


static NSDictionary *translations;
static NSMutableArray *missingTranslations;
static NSString *updateUrl;


@implementation FTLang

#pragma mark Memory management

+ (void)clean {
	[translations release];
	[missingTranslations release];
	[updateUrl release];
}

#pragma mark Reporting

+ (void)reportMissingTranslation:(NSString *)key andComment:(NSString *)comment {
	if (!missingTranslations) missingTranslations = [[NSMutableArray alloc] init];
	[missingTranslations addObject:key];
}

+ (void)submitMissingTranslations {
	
}

#pragma mark File cache path

+ (NSArray *)availableLanguages {
	return [NSArray array];
}

+ (NSString *)currentLanguage {
	return @"en";
}

+ (NSString *)filenameForLang:(NSString *)lang {
	return [NSString stringWithFormat:@"%@.lang", lang];
}

+ (NSString *)getPathForFileInLanguage:(NSString *)lang {
	return [[[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"langs"] stringByAppendingPathComponent:[self filenameForLang:lang]];
}

#pragma mark Lang update checks

+ (BOOL)needsUpdate {
	return YES;
}

#pragma mark Update process

- (void)downloadLanguage:(FTLang *)lang {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@synchronized(self) {
		NSDictionary *d = [FTDataJson jsonDataFromUrl:updateUrl];
		if (!d) [FTError handleErrorWithString:@"No language file available"];
		else {
			NSLog(@"Youuuu haaaaave toooo finiiiiish thiiiiis ooooooneeeeee!!!!! :)");
			abort();
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

+ (BOOL)loadLocalizationFromCache {
	NSString *file = [self getPathForFileInLanguage:[self currentLanguage]];
	if ([FTFilesystemIO isFile:file]) {
		[translations release];
		translations = [NSDictionary dictionaryWithContentsOfFile:file];
		[translations retain];
		return YES;
	}
	else return NO;
}

+ (void)loadLocalTranslations {
	if (![self loadLocalizationFromCache]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:[self filenameForLang:[self currentLanguage]] ofType:nil];
		if (!path) path = [[NSBundle mainBundle] pathForResource:@"default.lang" ofType:nil];
		if (path) {
			NSDictionary *d = [FTDataJson jsonDataFromString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
			[translations release];
			translations = [NSDictionary dictionaryWithContentsOfFile:[d objectForKey:@"data"]];
			[translations retain];
			[translations writeToFile:path atomically:YES];
		}
		else [FTError handleErrorWithString:@"There is no local traslation file in the bundle, please add default.lang or any other localization."];
	}
}

+ (void)loadTranslations {
	if (![self loadLocalizationFromCache]) {
		NSString *file = [self getPathForFileInLanguage:[self currentLanguage]];
		NSDictionary *t = [FTDataJson jsonDataFromUrl:@"sooooomeeeeefaaaaakeeeeurrrrrllll :)"];
		if (t) {
			[[t objectForKey:@"data"] writeToFile:file atomically:YES];
			[translations release];
			translations = [t objectForKey:@"data"];
			[translations retain];
		}
		else {
			[FTError handleErrorWithString:@"Translations could not be loaded"];
			[self loadLocalTranslations];
		}
	}
}

//+ (NSDictionary *)translations {
//	if (!translations) [self loadTranslations];
//	return translations;
//}

+ (NSString *)get:(NSString *)key comment:(NSString *)comment {
	return key;
	if (!translations) [self loadTranslations];
	if (translations) {
		NSString *ret = [translations objectForKey:key];
		if (!ret) {
			if ([FTProject debugging]) {
				[FTError handleErrorWithString:[NSString stringWithFormat:@"No translation for key: %@", key]];
				[self reportMissingTranslation:key andComment:comment];
			}
		}
		return ret;
	}
	else {
		[FTError handleErrorWithString:@"Missing translations"];
	}
	return NSLocalizedString(key, comment);
}

+ (NSString *)get:(NSString *)key {
	return [self get:key comment:@""];
}

+ (void)prepareWithUrl:(NSString *)url {
	[updateUrl release];
	updateUrl = url;
	[updateUrl retain];
	[self update];
}

+ (NSString *)currentLangVersion {
	return @"en";
}

+ (void)update {
	FTLang *lng = [[FTLang alloc] init];
	[NSThread detachNewThreadSelector:@selector(startBackgroundDownloading:) toTarget:lng withObject:lng];
}

#pragma mark Initialization

+ (void)initializeWithBaseUrl:(NSString *)baseUrl {
	[updateUrl release];
	updateUrl = baseUrl;
	[updateUrl retain];
	[self loadLocalTranslations];
}
	 



@end
