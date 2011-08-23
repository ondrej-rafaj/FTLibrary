//
//  FTLanguageManager.h
//  FTLibrary
//
//  Created by Fuerte International on 17/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FTLocalizedString(key, comment)			[FTLanguageManager get:(key) comment:(comment)]
#define FTLangGet(key)							[FTLanguageManager get:(key)] 

@interface FTLanguage : NSObject {
	
    NSString *key;
    NSString *url;
    NSDictionary *data;
	
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDictionary *data;

@end

@interface FTLanguageManager : NSObject

+ (void)initializeWithLocalURL:(NSString *)localeUrl remoteURL:(NSString *)remoteUrl andDefaultLanguage:(NSString *)language;

+ (void)setLocaleURL:(NSString *)url;
+ (void)setRemoteURL:(NSString *)url;
+ (void)setDefaultLanguage:(NSString *)lang;

+ (void)importLanguages;
+ (NSString *)get:(NSString *)key comment:(NSString *)comment;
+ (NSString *)get:(NSString *)key;

+ (void)submitMissingTranslationReport;


@end
