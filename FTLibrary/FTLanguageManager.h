//
//  FTLanguageManager.h
//  Calpol
//
//  Created by Fuerte International on 17/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

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
+ (void)setDefaultLanguage:(NSString *)lang;
+ (void)importLanguagesFromURL:(NSString *)urlString;
+ (NSString *)get:(NSString *)key comment:(NSString *)comment;
+ (NSString *)get:(NSString *)key;


@end
