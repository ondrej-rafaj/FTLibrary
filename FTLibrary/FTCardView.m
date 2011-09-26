//
//  FTCardView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTCardView.h"
#import "UIColor+Tools.h"


@implementation FTCardView

@synthesize shadow;
@synthesize border;
@synthesize cardView;
@synthesize cardViewOverlay;
@synthesize contentView;
@synthesize contentViewImage;
@synthesize contentViewOvelay;


#pragma mark Positioning

- (CGRect)frameForBorder {
	return self.bounds;
}

- (CGRect)frameForCardView {
	CGRect r = [self frameForBorder];
	r.origin.x = _borderThickness;
	r.origin.y = _borderThickness;
	r.size.width -= (2 * _borderThickness);
	r.size.height -= (2 * _borderThickness);
	return r;
}

- (CGRect)frameForContentView {
	CGRect r = [self frameForBorder];
	CGFloat t = (_borderThickness + _contentMargin);
	r.origin.x = t;
	r.origin.y = t;
	r.size.width -= (2 * t);
	r.size.height -= (2 * t);
	return r;
}

#pragma mark Layout

- (void)layoutViews {
	if (_style != FTCardViewStyleCustom) {
		[border setFrame:[self frameForBorder]];
		[cardView setFrame:[self frameForCardView]];
		[contentView setFrame:[self frameForContentView]];
		[contentViewImage setFrame:contentView.bounds];
		[contentViewOvelay setFrame:contentView.bounds];
	}
}

#pragma Creating elements

#pragma mark Initialization

- (void)initializeView {
	[self setBackgroundColor:[UIColor whiteColor]];
	
	_borderThickness = 1;
	_contentMargin = 12;
	
	// Create the border line view
	border = [[UIView alloc] init];
	[border setBackgroundColor:[UIColor lightGrayColor]];
	[self addSubview:border];
	
	// Create the card view
	cardView = [[UIView alloc] init];
	[cardView setBackgroundColor:[UIColor whiteColor]];
	[self addSubview:cardView];
	
	// Create content view
	contentView = [[UIView alloc] init];
	[contentView setBackgroundColor:[UIColor clearColor]];
	[self addSubview:contentView];
	
	// Image view in content view
	contentViewImage = [[FTImageView alloc] init];
	[contentViewImage setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	//[contentViewImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[contentView addSubview:contentViewImage];
	
	// Creating content view overlay
	contentViewOvelay = [[UIView alloc] init];
	[contentViewOvelay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
	[contentViewOvelay setAlpha:0];
	[contentViewOvelay setHidden:YES];
	[contentView addSubview:contentViewOvelay];
	
	// Layout all elements
	[self layoutViews];
}

#pragma mark Settings

- (void)setStyle:(FTCardViewStyle)style {
	_style = style;
	[self layoutViews];
}

- (FTCardViewStyle)style {
	return _style;
}

- (void)setBorderThickness:(CGFloat)borderThickness {
	_borderThickness = borderThickness;
	[self layoutViews];
}

- (CGFloat)borderThickness {
	return _borderThickness;
}

- (void)setContentMargin:(CGFloat)contentMargin {
	_contentMargin = contentMargin;
	[self layoutViews];
}

- (CGFloat)contentMargin {
	return _contentMargin;
}

- (void)toggleContentViewOverlay:(BOOL)animated {
	if (animated) [UIView beginAnimations:nil context:nil];
	
	if (animated) [UIView commitAnimations];
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
