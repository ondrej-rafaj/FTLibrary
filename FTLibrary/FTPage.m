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

#pragma mark Debug settings

- (void)enableIndexLabel {
	UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont boldSystemFontOfSize:40]];
	[label setTextColor:[UIColor blackColor]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setText:[NSString stringWithFormat:@"Ix: %d", pageIndex]];
	[self addSubview:label];
	[label release];
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
