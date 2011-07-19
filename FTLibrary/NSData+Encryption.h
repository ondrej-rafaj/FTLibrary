//
//  NSData+Encryption.h
//  FTLibrary
//
//  Created by Simon Lee on 17/02/2010.
//  Copyright 2010 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSData (Encryption)

- (NSData *)AESEncryptWithKey:(NSString *)key;
- (NSData *)AESDecryptWithKey:(NSString *)key;
- (NSData *)SHA1Hash;

@end
