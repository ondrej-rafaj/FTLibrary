//
//  NSString+IGTools.m
//  Book
//
//  Created by Ondrej Rafaj on 09/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSString+IGTools.h"


@implementation NSString (NSString_IGTools)

+ (NSString *)stringFromNumber:(int)number withCharacterSizeLength:(int)numberOfChars {
    NSString *no = [NSString stringWithFormat:@"%d", number];
    int len = [no length];
    for (int i = numberOfChars; i > len; i--) {
        no = [NSString stringWithFormat:@"0%@", no];
    }
    return no;
}

@end
