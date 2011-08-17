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
static NSString *translationsURL;

@implementation FTLanguageManager

#pragma mark Reporting

+ (void)setTranslationsURL:(NSString *)url {
    if (translationsURL) [translationsURL release];
    translationsURL = [url retain];
}

+ (void)setDefaultLanguage:(NSString *)lang {
    if (defaultLanguage) [defaultLanguage release];
    defaultLanguage = [lang retain];
}

+ (void)reportMissingTranslation:(NSString *)key andComment:(NSString *)comment {
	if (!missingTranslations) missingTranslations = [[NSMutableArray alloc] init];
	[missingTranslations addObject:key];
}

+ (void)importLanguagesFromURL:(NSString *)urlString {
    //setup translation
    if (!translations) {
        translations = [[NSMutableDictionary alloc] init];
    }
    
    //operation
    BOOL isDefault = NO;
    if (!urlString || [urlString isEqualToString:@""]) urlString = translationsURL;
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *dataString = [FTDataJson jsonDataFromUrl:urlString];
    NSArray *allLangs = [dataString objectForKey:@"data"];
    
    for (NSDictionary *dict in allLangs) {
        NSString *key = [[dict allKeys] objectAtIndex:0];
        NSString *url = [[allLangs objectAtIndex:0] objectForKey:key];
        if ([translations objectForKey:key] &&[[[translations objectForKey:key] objectForKey:@"url"] isEqualToString:url]) continue;
        NSDictionary *thisLangData = [FTDataJson jsonDataFromUrl:url];
        NSDictionary *data = [thisLangData objectForKey:@"data"];
        if (data) continue;
        
        FTLanguage *language = [[FTLanguage alloc] init];
        language.key = key;
        language.url = url;
        language.data = data;
        [translations setObject:language forKey:key];
        
        if (!isDefault && [key isEqualToString:@"en"]) isDefault = YES;
    }
    
    if (!isDefault) {
        [FTError handleErrorWithString:@"Default language EN not found on wellBacked app"];
    }

}


+ (NSString *)get:(NSString *)key comment:(NSString *)comment {
	if (!translations) return key;
    if (!defaultLanguage) defaultLanguage = @"en";
    FTLanguage *language = [translations objectForKey:defaultLanguage]; 
    NSString *ret = [language.data objectForKey:key];
    if (!ret && [FTProject debugging] && NO) {
        [FTError handleErrorWithString:[NSString stringWithFormat:@"No translation for language :%@ at key: %@", defaultLanguage, key]];
        [self reportMissingTranslation:key andComment:comment];
    }
    return ret;
}

+ (NSString *)get:(NSString *)key {
	return [self get:key comment:@""];
}

@end
