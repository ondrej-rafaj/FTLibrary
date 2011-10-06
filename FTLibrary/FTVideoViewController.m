//
//  FTVideoViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 11/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import "FTVideoViewController.h"



@implementation FTVideoViewController

@synthesize url = _url;
@synthesize player = _player;

static UIStatusBarStyle originalStatusBarStyle;

#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        // Custom initialization
        self.url = url;
    }
    return self;
}

- (id)initWithVideoPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        // Custom initialization
        self.url = [NSURL URLWithString:filePath];
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [_url release], _url = nil;
    [_player release], _player = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:self.url];
    [self.player.view setFrame:self.view.bounds];
    [self.player setFullscreen:YES];
    [self.player prepareToPlay];
    [self.view addSubview:self.player.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    originalStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player stop];
    [[UIApplication sharedApplication] setStatusBarStyle:originalStatusBarStyle];
}


@end
