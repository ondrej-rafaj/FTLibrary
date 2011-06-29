//
//  NSString+Tools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 09/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSString+Tools.h"


@implementation NSString (Tools)

+ (NSString *)stringFromNumber:(int)number withCharacterSizeLength:(int)numberOfChars {
    NSString *no = [NSString stringWithFormat:@"%d", number];
    int len = [no length];
    for (int i = numberOfChars; i > len; i--) {
        no = [NSString stringWithFormat:@"0%@", no];
    }
    return no;
}

@end
