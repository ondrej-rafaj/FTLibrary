//
//  FTCacheService.h
//  FTLibrary
//
//  Created by Simon Lee on 18/02/2010.
//  Copyright 2010 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTCacheService : NSObject {
	NSMutableDictionary *cacheItems;
}

+ (FTCacheService *)instance;

- (void)freeMemory;

- (void)cacheItem:(id)item forKey:(id<NSObject>)key;
- (id)getCachedItemForKey:(id<NSObject>)key;

@end
