//
//  FTDownload.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDownload.h"
#import "ASIDownloadCache.h"


@implementation FTDownload

@synthesize delegate;
@synthesize urlPath;
@synthesize status;
@synthesize downloadRequest;
@synthesize progressView;
@synthesize isCachingEnabled;
@synthesize bytesDownloaded;
@synthesize bytesTotal;
@synthesize progressBarValue;
@synthesize percentDownloaded;

#pragma mark Initialization

- (void)resetValues {
    status = FTDownloadStatusInactive;
    bytesDownloaded = 0;
    bytesTotal = 0;
    progressBarValue = 0;
    percentDownloaded = 0;
    isCachingEnabled = NO;
}

- (void)doInit {
    [self resetValues];
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithPath:(NSString *)url {
    self = [super init];
    if (self) {
        urlPath = url;
        [urlPath retain];
        [self doInit];        
    }
    return self;
}

#pragma mark Calculations

- (CGFloat)getDownloadStatusInPercents {
    return progressBarValue * 100;
}

#pragma mark Downloading data

- (void)startDownloadWithUrl:(NSString *)url {
    //[self resetValues];
    if (url) {
        [urlPath release];
        urlPath = url;
        [urlPath retain];
    }
    downloadRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlPath]];
    if (isCachingEnabled) {
		[downloadRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
		[downloadRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
		[downloadRequest setDownloadCache:[ASIDownloadCache sharedCache]];
	}
    [downloadRequest retain];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [downloadRequest setShouldContinueWhenAppEntersBackground:YES];
#endif
    //[downloadRequest setDidFailSelector:@selector(aaa)];
    [downloadRequest setNumberOfTimesToRetryOnTimeout:2];
    [downloadRequest setDelegate:self];
    [downloadRequest setDownloadProgressDelegate:self];
    [downloadRequest startAsynchronous];
}

- (void)startDownload {
    if (urlPath) [self startDownloadWithUrl:nil];
}

- (void)cancelDownload {
    if (downloadRequest) {
        if ([downloadRequest isExecuting]) [downloadRequest cancel];
    }
}

#pragma mark Progress delegate methods

- (void)fireProgressDelegateMethods {
    if ([delegate respondsToSelector:@selector(downloadDataPercentageChanged:forObject:)]) {
        [delegate downloadDataPercentageChanged:[self getDownloadStatusInPercents] forObject:self];
    }
    if ([delegate respondsToSelector:@selector(downloadDataStatusChanged:withTotalBytes:forObject:)]) {
        [delegate downloadDataStatusChanged:bytesDownloaded withTotalBytes:bytesTotal forObject:self];
    }
}

- (void)setProgress:(float)newProgress {
    if (progressView) {
        [progressView setProgress:newProgress];
    }
    progressBarValue = newProgress;
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    bytesDownloaded += bytes;
    [self fireProgressDelegateMethods];
    NSLog(@"didReceiveBytes: %lld", bytes);
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength {
    bytesTotal += newLength;
    [self fireProgressDelegateMethods];
}

#pragma mark Request delegate methods

- (void)fireDownloadStatusDelegateMethod {
    if ([delegate respondsToSelector:@selector(downloadStatusChanged:forObject:)]) {
        [delegate downloadStatusChanged:status forObject:self];
    }
}

- (void)requestStarted:(ASIHTTPRequest *)request {
    bytesTotal = 0;
    bytesDownloaded = 0;
    status = FTDownloadStatusActive;
    if ([delegate respondsToSelector:@selector(downloadStarted:)]) {
        [delegate downloadStarted:self];
    }
    [self fireDownloadStatusDelegateMethod];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [downloadRequest release];
    downloadRequest = nil;
    status = FTDownloadStatusFailed;
    [self fireDownloadStatusDelegateMethod];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    status = FTDownloadStatusSuccessful;
    [self fireDownloadStatusDelegateMethod];
}

#pragma mark Settings

- (void)cachingEnabled:(BOOL)enabled {
    isCachingEnabled = enabled;
}

#pragma mark Memory managemnt

- (void)dealloc {
    [urlPath release];
    [downloadRequest release];
    [super dealloc];
}


@end
