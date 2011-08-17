//
//  NSString+Tools.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Tools)

+ (NSString *)stringFromNumber:(int)number withCharacterSizeLength:(int)numberOfChars;

- (NSString *)stringByAppendingUrlPathComponent:(NSString *)component;


@end
