//
//  FTStoreGridViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreGridViewCell.h"
#import "UIView+Layout.h"


@implementation FTStoreGridViewCell

@synthesize storeView;
@synthesize title;
@synthesize description;
@synthesize price;
@synthesize buyButton;


#pragma mark Initialization

- (void)initializeView {
	CGRect r = [self.contentView bounds];
	r.size.height -= 120;
	storeView = [[UIView alloc] initWithFrame:r];
	[storeView setBackgroundColor:[UIColor redColor]];
	[self.contentView addSubview:storeView];
	
	[imageView removeFromSuperview];
	CGFloat m = 10;
	CGFloat h = [storeView height];
	CGFloat height = (h - (2 * m));
	CGFloat width = ((300 * height) / 400);
	[imageView setFrame:CGRectMake(m, m, width, height)];
	[storeView addSubview:imageView];
}

#pragma mark Memory management

- (void)dealloc {
	[storeView release];
	[title release];
	[description release];
	[price release];
	[buyButton release];
	[super dealloc];
}


@end
