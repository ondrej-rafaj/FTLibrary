//
//  FTLang.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTLang : NSObject

+ (void)initializeWithBaseUrl:(NSString *)baseUrl;

+ (void)prepareWithUrl:(NSString *)url;

+ (NSString *)get:(NSString *)key;

+ (NSString *)currentLangVersion;

+ (void)update;

+ (BOOL)needsUpdate;

+ (void)submitMissingTranslations;

+ (void)clean;


@end
