//
//  FTCachedImageLoader.m
//  FTLibarary
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "FTCachedImageLoader.h"
#import "FTDiskCache.h"

const NSInteger kMaxDownloadConnections		= 1;

static FTCachedImageLoader *sharedInstance;


@interface FTCachedImageLoader (Privates)

- (void)loadImageForClient:(id<FTImageConsumer>)client;
- (BOOL)loadImageRemotelyForClient:(id<FTImageConsumer>)request;

@end


@implementation FTCachedImageLoader

- (void)dealloc {
	[_imageDownloadQueue cancelAllOperations];
	[_imageDownloadQueue release];

	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		_imageDownloadQueue = [[NSOperationQueue alloc] init];
		[_imageDownloadQueue setMaxConcurrentOperationCount:kMaxDownloadConnections];
	}
	return self;
}


- (void)addClientToDownloadQueue:(id<FTImageConsumer>)client {
	[_imageDownloadQueue setSuspended:NO];
	NSOperation *imageDownloadOp = [[[NSInvocationOperation alloc] initWithTarget:self 
																		 selector:@selector(loadImageForClient:) 
																		   object:client] autorelease];
	[_imageDownloadQueue addOperation:imageDownloadOp];
}

- (void)loadImageForClient:(id<FTImageConsumer>)client {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    UIImage *cachedImage = [self cachedImageForClient:client];

    if (cachedImage) {
        [client renderImage:cachedImage];
    } 
	else if (![self loadImageRemotelyForClient:client]) {
//		NSLog(@"image download failed, trying again: %@", client);
		[self addClientToDownloadQueue:client];
	}
	
	[pool release];
}

- (void)suspendImageDownloads {
	[_imageDownloadQueue setSuspended:YES];
}

- (void)resumeImageDownloads {
	[_imageDownloadQueue setSuspended:NO];
}

- (void)cancelImageDownloads {
	[_imageDownloadQueue cancelAllOperations];
}

- (UIImage *)cachedImageForClient:(id<FTImageConsumer>)client {
	NSData *imageData = nil;
	UIImage *image = nil;
	
	NSURLRequest *request = [client request];
	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	
	if (cachedResponse) {
//		NSLog(@"found cached image data for %@", [request URL]);
		imageData = [cachedResponse data];
		image = [UIImage imageWithData:imageData];
	}
	
	if (image == nil && 
		(imageData = [[FTDiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]])) {
		NSURLResponse *response = [[[NSURLResponse alloc] initWithURL:[request URL] 
															 MIMEType:@"image/jpeg" 
												expectedContentLength:[imageData length] 
													 textEncodingName:nil] 
								   autorelease];
		[[FTDiskCache sharedCache] cacheImageData:imageData 
										 request:request 
										response:response];
		image = [UIImage imageWithData:imageData];
	}
	
//	if (image == nil) {
//		NSLog(@"unable to find image data in cache: %@", request);
//	}
	
	return image;
}

- (BOOL)loadImageRemotelyForClient:(id<FTImageConsumer>)client {
	//	NSLog(@"loading image data remotely for %@", [self imageURL]);
	NSURLResponse *response = nil;
	NSError *error = nil;

	NSURLRequest *request = [client request];
	NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error != nil) {
		NSLog(@"ERROR RETRIEVING IMAGE at %@: %@", request, error);
		NSLog(@"User info: %@", [error userInfo]);
		if ([[error userInfo] objectForKey:NSUnderlyingErrorKey]) {
			NSLog(@"underlying error info: %@", [[[error userInfo] objectForKey:NSUnderlyingErrorKey] userInfo]);
		}

        NSInteger code = [error code];
        if (code == NSURLErrorUnsupportedURL ||
            code == NSURLErrorBadURL ||
            code == NSURLErrorBadServerResponse ||
            code == NSURLErrorRedirectToNonExistentLocation ||
            code == NSURLErrorFileDoesNotExist ||
            code == NSURLErrorFileIsDirectory ||
            code == NSURLErrorRedirectToNonExistentLocation) {
            // the above status codes are permanent fatal errors;
            // don't retry
            return YES;
        }
        [error autorelease];

	} else if (imageData != nil && response != nil) {
		[[FTDiskCache sharedCache] cacheImageData:imageData 
										 request:request
										response:response];
		
		UIImage *image = [UIImage imageWithData:imageData];
		if (image == nil) {
//			NSLog(@"removing image data for: %@", [client request]);
			[[FTDiskCache sharedCache] clearCachedDataForRequest:[client request]];
		} else {
			[client renderImage:image];
			return YES;
		}

	} else {
		NSLog(@"Unknown error retrieving image %@ (response is null)", request);
	}
	return NO;
}


#pragma mark
#pragma mark ---- singleton implementation ----

+ (FTCachedImageLoader *)sharedImageLoader {
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}


@end
