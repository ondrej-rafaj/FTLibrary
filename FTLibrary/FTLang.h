//
//  FTLang.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTLang : NSObject

+ (void)prepareWithUrl:(NSString *)url;

+ (NSString *)get:(NSString *)key;

+ (NSInteger)currentLangVersion;

+ (void)update;


@end
