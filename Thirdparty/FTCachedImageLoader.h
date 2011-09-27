//
//  FTCachedImageLoader.h
//  FTLibrary
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FTImageConsumer <NSObject>

- (NSURLRequest *)request;
- (void)renderImage:(UIImage *)image;

@end


@interface FTCachedImageLoader : NSObject {

@private

	NSOperationQueue *_imageDownloadQueue;
	
}


+ (FTCachedImageLoader *)sharedImageLoader;


- (void)addClientToDownloadQueue:(id<FTImageConsumer>)client;
- (UIImage *)cachedImageForClient:(id<FTImageConsumer>)client;

- (void)suspendImageDownloads;
- (void)resumeImageDownloads;
- (void)cancelImageDownloads;


@end
