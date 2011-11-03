//
//  FTGridViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTGridViewCell.h"

@implementation FTGridViewCell

@synthesize imageView;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
	if (self) {
		imageView = [[FTImageView alloc] initWithFrame:self.bounds];
		[imageView setBackgroundColor:[UIColor whiteColor]];
		[imageView setContentMode:UIViewContentModeScaleAspectFill];
		[imageView setClipsToBounds:YES];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self.contentView addSubview:imageView];
	}
	return self;
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
	[super dealloc];
}


@end
