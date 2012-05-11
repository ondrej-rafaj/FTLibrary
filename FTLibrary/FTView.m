//
//  FTView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 12/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "UIColor+Tools.h"


@implementation FTView

@synthesize backgroundImage;


#pragma mark Initialization

- (void)initializeView {
	
}

/* [super init] will call initWithFrame: so no need to override the init method
 * MOREOVER a view should never be initialized using init, but initWithFrame which is the 
 * designated initializer */

//- (id)init {
//	self = [super init];
//	if (self) {
//		[self initializeView];
//	}
//	return self;
//}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initializeView];
	}
	return self;
}

#pragma mark Background

- (void)enableBackgroundImage:(UIImage *)image {
	backgroundImage = [[FTImageView alloc] initWithFrame:self.bounds];
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
