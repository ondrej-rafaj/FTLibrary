//
//  FTLanguageManager.m
//  Calpol
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

@implementation FTLanguageManager


+ (void)setLocaleURL:(NSString *)url {
    if (localeURL) [localeURL release];
    NSURL *dirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
    
    // TODO: import local lang in main thread, then search for internet in background
    // Not using background thread because app will request empy data otherwise
    // [NSThread detachNewThreadSelector:@selector(importLanguages) toTarget:self withObject:nil];
}

#pragma mark Reporting

+ (void)reportMissingTranslation:(NSString *)key andComment:(NSString *)comment {
	if (!missingTranslations) missingTranslations = [[NSMutableArray alloc] init];
	[missingTranslations addObject:key];
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
        NSDictionary *dataDictionary = [FTDataJson jsonDataFromUrl:remoteURL];
        allLangs = [dataDictionary objectForKey:@"data"];
        
        for (NSDictionary *dict in allLangs) {
            NSString *key = [[dict allKeys] objectAtIndex:0];
            NSString *url = [[allLangs objectAtIndex:0] objectForKey:key];
            NSDictionary *thisLangData = [FTDataJson jsonDataFromUrl:url];
            NSDictionary *data = [thisLangData objectForKey:@"data"];
            if (!data) continue;
            
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
    
    //[pool drain];
    

}


+ (NSString *)get:(NSString *)key comment:(NSString *)comment {
	if (!translations) return [NSString stringWithFormat:@"[%@]", key];
    if (!defaultLanguage) defaultLanguage = @"en";
    FTLanguage *language = [translations objectForKey:defaultLanguage]; 
    NSString *ret = [language.data objectForKey:key];
    if (!ret && [FTProject debugging] && NO) {
        [FTError handleErrorWithString:[NSString stringWithFormat:@"No translation for language :%@ at key: %@", defaultLanguage, key]];
        [self reportMissingTranslation:key andComment:comment];
    }
    if (!ret) NSLog(@"Missing Translation for %@", key);
    return (ret)? ret : [NSString stringWithFormat:@"[%@]", key];
}

+ (NSString *)get:(NSString *)key {
	return [self get:key comment:@""];
}

@end
