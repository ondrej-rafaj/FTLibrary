//
//  FTPageImageViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 25/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPageImageViewController.h"


@implementation FTPageImageViewController

@synthesize pageImage;


#pragma mark Initialization

- (void)doInit {
	pageImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[pageImage setUserInteractionEnabled:YES];
	[pageImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
	[pageImage setContentMode:UIViewContentModeScaleAspectFit];
	[self.view addSubview:pageImage];
}

- (id)init {
	self = [super init];
	if (self) {
		[self doInit];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	self = [super init];
	if (self) {
		[self doInit];
		[pageImage setImage:image];
	}
	return self;
}

+ (id)instanceWithImage:(UIImage *)image {
	return [[FTPageImageViewController alloc] initWithImage:image];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark Memory management

- (void)dealloc {
	[pageImage release];
	[super dealloc];
}


@end
