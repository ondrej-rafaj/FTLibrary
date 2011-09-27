//
//  FTDiskCache.h
//  FTLibrary
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTDiskCache : NSObject {

@private
	
	NSString *_cacheDir;
	NSUInteger _cacheSize;
	
}


@property (nonatomic, readonly) NSUInteger sizeOfCache;
@property (nonatomic, readonly) NSString *cacheDir;


+ (FTDiskCache *)sharedCache;

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString;
- (void)cacheImageData:(NSData *)imageData request:(NSURLRequest *)request response:(NSURLResponse *)response;
- (void)clearCachedDataForRequest:(NSURLRequest *)request;


@end
