//
//  FTValidationText.h
//
//  FTLibrary
//
//  Created by Ondrej Rafaj on 1.4.10.
//
//  Copyright 2010 fuerteint.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTValidationText : NSObject {

}

+ (BOOL)isEmail:(NSString *)candidate;

+ (BOOL)isAlphanumeric:(NSString *)candidate;

+ (BOOL)isStringInCharacterSet:(NSString *)string characterSet:(NSMutableCharacterSet *)characterSet;


@end
