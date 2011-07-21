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


@interface FTVideoViewController : FTViewController {
    
    UIView *videoView;
    
}

@property (nonatomic, retain) UIView *videoView;


- (id)initWithVideoBundleFile:(NSString *)fileName;

- (id)initWithVideoUrl:(NSString *)url;

- (id)initWithVideoPath:(NSString *)filePath;



@end
