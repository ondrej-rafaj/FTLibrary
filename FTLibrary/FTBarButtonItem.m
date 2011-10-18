//
//  FTBarButtonItem.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 18/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTBarButtonItem.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Layout.h"


@implementation FTBarButtonItemButton
@synthesize barButtonItem = _barButtonItem;
@end


@implementation FTBarButtonItem

@synthesize customElement;


#pragma mark Setting styles

- (void)setStylesForButton:(FTBarButtonItemStyle)style {
	if (_style == FTBarButtonItemStyleInLineButtonBlack) {
		[customElement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[customElement setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:(([customElement isHighlighted]) ? 0.5 : 0.8)]];
		[customElement setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	}
	else if (_style == FTBarButtonItemStyleInLineButtonWhite) {
		[customElement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[customElement setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:(([customElement isHighlighted]) ? 0.5 : 0.3)]];
		[customElement setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
	}
	else if (_style == FTBarButtonItemStyleInLineButtonWhite) {
		[customElement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[customElement setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:(([customElement isHighlighted]) ? 0.5 : 0.3)]];
		[customElement setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
	}
}

- (void)setCustomStyle:(FTBarButtonItemStyle)style {
	_style = style;
	[self setStylesForButton:style];
}

- (FTBarButtonItemStyle)customStyle {
	return _style;
}

- (void)setAlpha:(CGFloat)alpha {
	[self.customElement setAlpha:alpha];
}

- (CGFloat)alpha {
	return self.customElement.alpha;
}

#pragma mark Button highlights

- (void)touchDown:(UIButton *)sender {
	[self setStylesForButton:_style];
}

- (void)touchUpInside:(UIButton *)sender {
	[self setStylesForButton:_style];
}

#pragma mark Initialization

- (id)initWithTitle:(NSString *)title withFTStyle:(FTBarButtonItemStyle)style target:(id)target action:(SEL)action {
	_style = style;
	self.customElement = [FTBarButtonItemButton buttonWithType:UIButtonTypeCustom];
	[customElement addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[customElement addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
	[customElement addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[customElement setTitle:title forState:UIControlStateNormal];
	[self setStylesForButton:_style];
	[[customElement titleLabel] setFont:[UIFont boldSystemFontOfSize:12]];
	[customElement sizeToFit];
	[customElement setHeight:26];
	[customElement setWidth:([customElement width] + 22)];
	[customElement.layer setCornerRadius:13];
	
	if (!customElement) return nil;
	self = [super initWithCustomView:customElement];
	if (self) {
		[customElement setBarButtonItem:self];
	}
	return self;
}

#pragma mark Memory management

- (void)dealloc {
	[customElement setBarButtonItem:nil];
	[customElement release];
	[super dealloc];
}


@end
