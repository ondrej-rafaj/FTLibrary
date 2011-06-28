//
//  FTText.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 1.4.10.
//  Copyright 2010 fuerteint.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTTextEncoding.h"


@interface FTText : NSObject {

}

+ (NSString *)removeNewLines:(NSString *)text;

+ (NSString *)replaceNewLinesWithEscapes:(NSString *)text;

+ (NSString *)getSafeText:(NSString *)text;

+ (NSString *)convertText:(NSString *)text fromEncoding:(NSStringEncoding)from toEncoding:(NSStringEncoding)to;

+ (NSString *)parseCodes:(NSDictionary *)codes inTemplate:(NSString *)templateString;


@end
