//
//  FTCacheService.m
//  FTLibrary
//
//  Created by Simon Lee on 18/02/2010.
//  Copyright 2010 Fuerte International. All rights reserved.
//

#import "FTCacheService.h"


@implementation FTCacheService

+ (FTCacheService *)instance  {
	static FTCacheService *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[FTCacheService alloc] init];
		}
	}
	
	return instance;
}

- (id)init {
	self = [super init];
	
	if(self != nil) {
		cacheItems = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return self;	
}

- (void)dealloc {
	[cacheItems release];
	[super dealloc];
}

- (void)freeMemory {
	[cacheItems removeAllObjects];
}

- (void)cacheItem:(id)item forKey:(id<NSObject>)key {
	if(item == nil) {
		return;
	}
	
	if([cacheItems objectForKey:key] != nil) {
		[cacheItems removeObjectForKey:key];
	}
	
	[cacheItems setObject:item forKey:key];
}

- (id)getCachedItemForKey:(id<NSObject>)key {
	return [cacheItems objectForKey:key];
}

@end
