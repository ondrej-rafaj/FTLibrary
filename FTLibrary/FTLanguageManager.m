//
//  FTLanguageManager.m
//  FTLibrary
//
//  Created by Fuerte International on 17/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLanguageManager.h"
#import "FTProject.h"
#import "FTData.h"
#import "FTDataJson.h"
#import "FTFilesystem.h"
#import "Reachability.h"
#import "FTSystem.h"
#import "SBJsonWriter.h"
#import "ASIFormDataRequest.h"
#import "FTFilesystemPaths.h"

#pragma mark FTLanguage

@implementation FTLanguage

@synthesize key;
@synthesize url;
@synthesize data;


- (void)dealloc {
    
    [key release], key = nil;
    [url release], url = nil;
    [data release], data = nil;
    [super dealloc];
}

@end

#pragma mark --
#pragma mark FTLang

static NSMutableDictionary *translations;
static NSMutableArray *missingTranslations;
static NSString *defaultLanguage;
static NSString *remoteURL;
static NSString *localeURL;
static NSString *appID;

@implementation FTLanguageManager


+ (void)setLocaleURL:(NSString *)url {
    if (localeURL) [localeURL release];
    NSURL *dirURL = [NSURL fileURLWithPath:[FTFilesystemPaths getDocumentsDirectoryPath]];
    localeURL = [[NSString alloc] initWithFormat:@"%@/%@", [dirURL path], url];
}

+ (void)setRemoteURL:(NSString *)url {
    if (remoteURL) [remoteURL release];
    remoteURL = [url retain];
}

+ (void)setDefaultLanguage:(NSString *)lang {
    if (defaultLanguage) [defaultLanguage release];
    defaultLanguage = [lang retain];
}

+ (void)initializeWithLocalURL:(NSString *)locale remoteURL:(NSString *)remote andDefaultLanguage:(NSString *)language {
    [self setLocaleURL:locale];
    [self setRemoteURL:remote];
    [self setDefaultLanguage:language];
    [self importLanguages];
    if (missingTranslations) [missingTranslations removeAllObjects];
    
    // TODO: import local lang in main thread, then search for internet in background
    // Not using background thread because app will request empty data otherwise
    // [NSThread detachNewThreadSelector:@selector(importLanguages) toTarget:self withObject:nil];
}

#pragma mark Reporting

+ (void)submitMissingTranslationReport {
    if (missingTranslations && [missingTranslations count] > 0) {
        //prepare report
        NSMutableString *report = [NSMutableString string];
        if (!appID) appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        [report appendFormat:@"WellBakedApp report:\nApp ID : %@\nDate: %@\n", appID, [[NSDate date] description]];
        [report appendFormat:@"list of missing translations:\n"];
        for (NSString *key in missingTranslations) {
            [report appendFormat:@"- %@\n", key];
        }
        
        //send report
        NSURL *url = [NSURL URLWithString:@"http://new.fuerteint.com/_files/well_baked_reports/wellbakedreport.php"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setPostValue:appID forKey:@"app_id"];
        [request setPostValue:report forKey:@"report"];
        [request startSynchronous];

        NSLog(@"response: %@ with error: %@",[request responseString], [[request error] description]);        
    }
    
}

+ (void)reportMissingTranslation:(NSString *)key andComment:(NSString *)comment {
	if (!missingTranslations) missingTranslations = [[NSMutableArray alloc] init];
    if (![missingTranslations containsObject:key]) [missingTranslations addObject:key];
    NSLog(@"Missing Translation for %@", key);
}

+ (void)importLanguages {
    //setup translation
    if (!translations) {
        translations = [[NSMutableDictionary alloc] init];
    }
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //operation
    BOOL isDefault = NO;
    BOOL hasInternet = [FTSystem isInternetAvailable];
    

    NSError *error = nil;
    
    if (hasInternet) {
        NSArray *allLangs;
        NSMutableDictionary *backUpData = [NSMutableDictionary dictionary];
        //NSDictionary *dataDictionary = [FTDataJson jsonDataFromUrl:remoteURL];
        //allLangs = [dataDictionary objectForKey:@"data"];
        
		//fix to allow only one language
		allLangs = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:remoteURL, @"en", nil]];
		
        for (NSDictionary *dict in allLangs) {
            NSString *key = [[dict allKeys] objectAtIndex:0];
            if ([[backUpData allKeys] containsObject:key]) continue;
            NSString *url = [[allLangs objectAtIndex:0] objectForKey:key];
            NSDictionary *thisLangData = [FTDataJson jsonDataFromUrl:url];
            NSDictionary *data = [thisLangData objectForKey:@"data"];
            if (!data || [data count] == 0) continue;
            
            FTLanguage *language = [[FTLanguage alloc] init];
            language.key = key;
            language.url = url;
            language.data = data;
            [translations setObject:language forKey:key];
            [backUpData setObject:data forKey:key];
            NSLog(@"%d translations found for Language %@", [data count], key);
            
            if (!isDefault && defaultLanguage && [key isEqualToString:defaultLanguage]) isDefault = YES;
        }
        
        //write to file for locale!
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString *dataString = [writer stringWithObject:backUpData error:&error];
        if (error) [FTError handleError:error];
        [dataString writeToFile:localeURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
        //[dataString writeToURL:[NSURL URLWithString:localeURL] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) [FTError handleError:error];
        
        
    }
    else {
        NSDictionary *allLangs;
        NSString *dataString = [NSString stringWithContentsOfFile:localeURL encoding:NSUTF8StringEncoding error:&error];
        allLangs = [FTDataJson jsonDataFromString:dataString];
        
        NSArray *allLangStrings = [allLangs allKeys];
        
        for (NSString *key in allLangStrings) {
            NSDictionary *data = [allLangs objectForKey:key];
            
            FTLanguage *language = [[FTLanguage alloc] init];
            language.key = key;
            language.url = nil;
            language.data = data;
            [translations setObject:language forKey:key];
            NSLog(@"%d translations found for Language %@ (backup)", [data count], key);
            
            if (!isDefault && defaultLanguage && [key isEqualToString:defaultLanguage]) isDefault = YES;
        }
        
    }

    if (!isDefault) {
        [FTError handleErrorWithString:@"Default language EN not found on wellBacked app"];
    }
}


+ (NSString *)get:(NSString *)key comment:(NSString *)comment {
//	return NSLocalizedString(key, comment);
	if (!translations) {
		if (![FTProjectInitialization debugging]) return key;
		else return [NSString stringWithFormat:@"[%@]", key];
	}
    if (!defaultLanguage) defaultLanguage = @"en";
    FTLanguage *language = [translations objectForKey:defaultLanguage]; 
    NSString *ret = [language.data objectForKey:key];
    if (!ret) {
        if ([FTProject debugging]) [FTError handleErrorWithString:[NSString stringWithFormat:@"No translation for language :%@ at key: %@", defaultLanguage, key]];
        [self reportMissingTranslation:key andComment:comment];
    }
	if (ret) return ret;
	else {
		if (![FTProjectInitialization debugging]) return key;
		else return [NSString stringWithFormat:@"[%@]", key];
	}
}

+ (NSString *)get:(NSString *)key {
	return [self get:key comment:@""];
}

@end
