//
//  FTLang.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTLanguageManager.h"


#define FTLocalizedString(key, comment)			[FTLanguageManager get:(key) comment:(comment)]
#define FTLangGet(key)							[FTLanguageManager get:(key)]


@interface FTLang : FTLanguageManager

+ (void)loadLocalTranslations __deprecated;

+ (NSString *)get:(NSString *)key __deprecated;

+ (NSString *)get:(NSString *)key comment:(NSString *)comment __deprecated;

@end
