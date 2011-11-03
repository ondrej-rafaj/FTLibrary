//
//  FTSearchBar.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTSearchBar.h"


@implementation FTSearchBar

@synthesize searchField;

#pragma mark Initialization

- (void)doInit {
	NSUInteger numViews = [self.subviews count];
	for(int i = 0; i < numViews; i++) {
		if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
			[self setSearchField:[self.subviews objectAtIndex:i]];
		}
	}
	if (!searchField) NSLog(@"No search text field has been found");
}

- (id)init {
	self = [super init];
	if (self) {
		[self doInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self doInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self doInit];
	}
	return self;
}

#pragma mark Layout

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark Memory management

- (void)dealloc {
	[searchField release];
	[super dealloc];
}

@end
