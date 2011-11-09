//
//  FTStoreHeaderView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 08/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreHeaderView.h"

@implementation FTStoreHeaderView

@synthesize imageView;

#pragma mark Project initialization

- (void)initializeView {
	[self setBackgroundColor:[UIColor clearColor]];
	
	UIView *v = [[UIView alloc] initWithFrame:self.bounds];
	[v setBackgroundColor:[UIColor whiteColor]];
	[self addSubview:v];
	[v makeMarginInSuperViewWithTopMargin:26 andSideMargin:15];
	imageView = [[FTImageView alloc] initWithFrame:self.bounds];
	[imageView setContentMode:UIViewContentModeScaleAspectFill];
	[v addSubview:imageView];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[v release];
	[imageView makeMarginInSuperView:8];
	[imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
	[super dealloc];
}


@end
