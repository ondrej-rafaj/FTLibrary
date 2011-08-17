//
//  FTLanguageManager.h
//  Calpol
//
//  Created by Fuerte International on 17/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FTLocalizedString(key, comment)			[FTLang get:(key) comment:(comment)]
#define FTLangGet(key)							[FTLang get:(key)]


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

+ (void)setTranslationsURL:(NSString *)url;
+ (void)setTranslationsURL:(NSString *)url;
+ (void)importLanguagesFromURL:(NSString *)urlString;
+ (NSString *)get:(NSString *)key comment:(NSString *)comment;
+ (NSString *)get:(NSString *)key;


@end
