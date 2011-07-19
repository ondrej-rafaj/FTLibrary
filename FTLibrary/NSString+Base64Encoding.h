//
//  NSString+Base64Encoding.h
//  Locassa
//
//  Created by Simon Lee on 29/10/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (Base64Encoding)

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;

@end
