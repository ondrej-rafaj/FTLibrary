//
//  FTDataPlist.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTData.h"


@interface FTDataPlist : FTData

+ (NSDictionary *)plistDictionaryFromString:(NSString *)string;

+ (NSDictionary *)plistDictionaryFromUrl:(NSString *)url;

+ (NSArray *)plistArrayFromString:(NSString *)string;

+ (NSArray *)plistArrayFromUrl:(NSString *)url;


@end
