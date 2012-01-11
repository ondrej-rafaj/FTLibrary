//
//  FTDownload.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDownload.h"
#import "ASIDownloadCache.h"
#import "FTError.h"

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
@synthesize downloadToFilePath = _downloadToFilePath;

#if NS_BLOCKS_AVAILABLE
@synthesize startBlock = _startBlock;
@synthesize progressBlock = _progressBlock;
@synthesize completionBlock = _completionBlock;
@synthesize failureBlock = _failureBlock;
#endif

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

#if NS_BLOCKS_AVAILABLE

- (id)initWithPath:(NSString *)url startBlock:(void (^)(void))start 
	 progressBlock:(void (^)(float progress))progress 
   completionBlock:(void (^)(NSString *stringResponse, NSData *dataResponse, NSURL *fileURL))completion 
	  failureBlock:(void (^)(FTError *error))failure
{
	self = [self initWithPath:url];
	if (self) {
		self.completionBlock = completion;
		self.startBlock = start;
		self.failureBlock = failure;
		self.progressBlock = progress;
	}
	return self;
}

#endif

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
	if (_downloadToFilePath) downloadRequest.downloadDestinationPath = _downloadToFilePath;
	NSLog(@"Download request: %@", downloadRequest.url.relativeString);
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
#if NS_BLOCKS_AVAILABLE
	if (_progressBlock) _progressBlock(newProgress);
#endif
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    bytesDownloaded += bytes;
    [self fireProgressDelegateMethods];
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength {
    bytesTotal += newLength;
    [self fireProgressDelegateMethods];
}

#pragma mark Request delegate methods

- (void)fireDownloadStatusDelegateMethod {
	if (delegate) {
		if ([delegate respondsToSelector:@selector(downloadStatusChanged:forObject:)]) {
			[delegate downloadStatusChanged:status forObject:self];
		}
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
#if NS_BLOCKS_AVAILABLE
	if (_startBlock) _startBlock();
#endif
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [downloadRequest release];
    downloadRequest = nil;
    status = FTDownloadStatusFailed;
    [self fireDownloadStatusDelegateMethod];
	NSLog(@"Request status code: %d", request.responseStatusCode);
	NSLog(@"Request error: %@", request.error.localizedDescription);
#if NS_BLOCKS_AVAILABLE
	if (_failureBlock) _failureBlock([FTError errorWithError:request.error]);
#endif
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    status = FTDownloadStatusSuccessful;
    [self fireDownloadStatusDelegateMethod];
#if NS_BLOCKS_AVAILABLE
	if (_completionBlock) _completionBlock(request.responseString, request.responseData, (_downloadToFilePath) ? [NSURL fileURLWithPath:_downloadToFilePath] : nil);
#endif
}

#pragma mark Settings

- (void)cachingEnabled:(BOOL)enabled {
    isCachingEnabled = enabled;
}

#pragma mark Memory managemnt

- (void)dealloc {
	[downloadRequest cancel];
	[downloadRequest setDelegate:nil];
    [downloadRequest release];
	[_downloadToFilePath release];
    [self setDelegate:nil];
    [urlPath release];
#if NS_BLOCKS_AVAILABLE
	[_startBlock release];
	[_progressBlock release];
	[_completionBlock release];
	[_failureBlock release];
#endif
	[super dealloc];
}


@end
