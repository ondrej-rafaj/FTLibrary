//
//  FTTableHeaderView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 20/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTTableHeaderView.h"


@implementation FTTableHeaderView

@synthesize titleLabel;
@synthesize backgroundImageView;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {	
    self = [super initWithFrame:frame];
    if (self) {
		[self setClipsToBounds:YES];
		
		// Background image canvas
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[backgroundImageView setBackgroundColor:[UIColor clearColor]];
		[backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self addSubview:backgroundImageView];
		
		// Title label
		CGRect r = self.bounds;
		r.origin.x += 6;
		//r.origin.y -= 2;
		r.size.width -= 12;
		titleLabel = [[UILabel alloc] initWithFrame:r];
		[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setShadowColor:[UIColor darkTextColor]];
		[titleLabel setShadowOffset:CGSizeMake(1 , 1)];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[self addSubview:titleLabel];
    }
    return self;
}

#pragma mark Draw rectangle

//- (void)drawRect:(CGRect)rect {
//    
//}

#pragma mark Memory management

- (void)dealloc {
	[titleLabel release];
	[backgroundImageView release];
    [super dealloc];
}


@end
