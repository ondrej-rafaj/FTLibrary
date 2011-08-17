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


@implementation FTLang

/*!
 * @deprecated Use [FTLanguaguageManager initializeWithURL: andDefaultLanguage:] instead
 */

+ (void)loadLocalTranslations {
    //
}


/*!
 * @deprecated Use FTLanguaguageManager instead
 */

+ (NSString *)get:(NSString *)key {
    return [super get:key];
}

/*!
 * @deprecated Use FTLanguaguageManager instead
 */

+ (NSString *)get:(NSString *)key comment:(NSString *)comment {
    return [super get:key comment:comment];
}


@end
