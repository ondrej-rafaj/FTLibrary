//
//  FTUnlimitedGridViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTUnlimitedGridViewCell.h"

@implementation FTUnlimitedGridViewCell

@synthesize reuseIdentifier;
@synthesize coordinate;

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame andReusableIdentifier:(NSString *)identifier {
	self = [super initWithFrame:frame];
	if (self) {
		[self setReuseIdentifier:identifier];
	}
	return self;
}

#pragma mark Settings

- (void)prepareForReuse {
	
}

#pragma mark Memory managemnt

- (void)dealloc {
	[reuseIdentifier release];
	[super dealloc];
}


@end
