//
//  FTCardView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTCardView.h"

@implementation FTCardView

@synthesize shadow;
@synthesize border;
@synthesize cardView;
@synthesize cardViewOverlay;
@synthesize contentView;
@synthesize contentViewImage;
@synthesize contentViewOvelay;


#pragma mark Positioning

#pragma mark Layout

- (void)layoutViews {
	if (_style != FTCardViewStyleCustom) {
		
	}
}

#pragma Creating elements

#pragma mark Initialization

#pragma mark Settings

- (void)setStyle:(FTCardViewStyle)style {
	_style = style;
	[self layoutViews];
}

- (FTCardViewStyle)style {
	return _style;
}

#pragma mark Memory management

- (void)dealloc {
	[shadow release];
	[border release];
	[cardView release];
	[cardViewOverlay release];
	[contentView release];
	[contentViewImage release];
	[contentViewOvelay release];
	[super dealloc];
}

@end
