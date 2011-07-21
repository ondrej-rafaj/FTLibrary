//
//  FTPage.m
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPage.h"


@implementation FTPage 

@synthesize pageDelegate;
@synthesize location;
@synthesize pageIndex;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	}
	return self;
}

#pragma mark Memory management

- (void)dealloc {
	if ([pageDelegate respondsToSelector:@selector(pageWillDispose:)]) {
		[pageDelegate pageWillDispose:self];
	}
	[location release];
	[super dealloc];
}


@end
