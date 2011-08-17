//
//  FTLang.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTLanguageManager.h"


#define FTLocalizedString(key, comment)			[FTLang get:(key) comment:(comment)]
#define FTLangGet(key)							[FTLang get:(key)]


@interface FTLang : FTLanguageManager

+ (void)loadLocalTranslations;

@end
