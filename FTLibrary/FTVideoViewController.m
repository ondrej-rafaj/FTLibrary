//
//  FTVideoViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 11/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import "FTVideoViewController.h"


@implementation FTVideoViewController

@synthesize videoView;

#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoBundleFile:(NSString *)fileName {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoUrl:(NSString *)url {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [videoView release];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end
