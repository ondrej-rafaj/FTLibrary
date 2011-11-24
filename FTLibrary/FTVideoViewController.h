//
//  FTVideoViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 11/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"
//#import "FTMediaVideoView.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol FTVideoViewControllerDelegate;
@interface FTVideoViewController : FTViewController {
    NSURL *_url;
    MPMoviePlayerController *_player;
    id<FTVideoViewControllerDelegate> _delegate;
    BOOL _shouldRotate;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, assign) id<FTVideoViewControllerDelegate> delegate;
@property (nonatomic, assign, getter=isShouldRotate) BOOL shouldRotate;

- (id)initWithVideoUrl:(NSURL *)url;
- (id)initWithVideoPath:(NSString *)filePath;


@end

@protocol FTVideoViewControllerDelegate <NSObject>
@optional
- (void)videoPlayerDidStop:(FTViewController *)videoController;
- (void)videoPlayerWillDisappear:(FTViewController *)videoController;
- (void)videoPlayerDidRespondTotouch:(FTViewController *)videoController;

@end