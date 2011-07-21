//
//  FTDownload.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


typedef enum {
    FTDownloadStatusInactive,
    FTDownloadStatusActive,
    FTDownloadStatusPaused,
    FTDownloadStatusSuccessful,
    FTDownloadStatusFailed
} FTDownloadStatus;


@class FTDownload;

@protocol FTDownloadDelegate <NSObject>

@optional

- (void)downloadStarted:(FTDownload *)object;

- (void)downloadDataStatusChanged:(long long)downloaded withTotalBytes:(long long)total forObject:(FTDownload *)object;

- (void)downloadDataPercentageChanged:(CGFloat)percentage forObject:(FTDownload *)object;

- (void)downloadStatusChanged:(FTDownloadStatus)downloadStatus forObject:(FTDownload *)object;

@end


@interface FTDownload : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate> {
    
    id <FTDownloadDelegate> delegate;
    
    NSString *urlPath;
    
    FTDownloadStatus status;
    
    ASIHTTPRequest *downloadRequest;
    
    UIProgressView *progressView;
    
    long long bytesDownloaded;
    long long bytesTotal;
    
    CGFloat progressBarValue;
    
    CGFloat percentDownloaded;
    
    BOOL isCachingEnabled;
    
}

@property (nonatomic, assign) id <FTDownloadDelegate> delegate;

@property (nonatomic, readonly) NSString *urlPath;

@property (nonatomic, readonly) FTDownloadStatus status;

@property (nonatomic, readonly) ASIHTTPRequest *downloadRequest;

@property (nonatomic, assign) UIProgressView *progressView;

@property (nonatomic, readonly) long long bytesDownloaded;
@property (nonatomic, readonly) long long bytesTotal;

@property (nonatomic, readonly) CGFloat progressBarValue;

@property (nonatomic, readonly) CGFloat percentDownloaded;

@property (nonatomic, readonly) BOOL isCachingEnabled;


- (id)initWithPath:(NSString *)url;

- (void)startDownload;

- (void)cancelDownload;

- (void)cachingEnabled:(BOOL)enabled;



@end
