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

@interface FTVideoViewController : FTViewController {
    NSURL *_url;
    MPMoviePlayerController *_player;
    
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) MPMoviePlayerController *player;


- (id)initWithVideoUrl:(NSURL *)url;
- (id)initWithVideoPath:(NSString *)filePath;



@end
