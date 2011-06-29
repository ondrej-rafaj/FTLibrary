//
//  FTData.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FTData : NSObject {
    
}

+ (NSData *)dataWithContentsOfUrl:(NSString *)url;

+ (NSString *)stringWithContentsOfUrl:(NSString *)url;

+ (BOOL)isEmpty:(NSString *)string;

+ (void)cacheValue:(id)object WithKey:(NSString *)key;

+ (id)cachedValueForKey:(NSString *)key;


@end
