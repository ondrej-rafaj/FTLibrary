//
//  FTView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 12/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"

@implementation FTView

@synthesize backgroundImage;


#pragma mark Background

- (void)enableBackgroundImage:(UIImage *)image {
	backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
	[backgroundImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[backgroundImage setImage:image];
	[self addSubview:backgroundImage];
	[self sendSubviewToBack:backgroundImage];
}

#pragma mark Memory management

- (void)dealloc {
	[backgroundImage release];
	[super dealloc];
}


@end
