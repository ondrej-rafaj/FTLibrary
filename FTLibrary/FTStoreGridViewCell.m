//
//  FTStoreGridViewCell.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreGridViewCell.h"
#import "FTLang.h"
#import "UIView+Layout.h"
#import "UILabel+DynamicHeight.h"
#import "UIColor+Tools.h"


@implementation FTStoreGridViewCell

@synthesize storeView;
@synthesize title;
@synthesize description;
@synthesize price;
@synthesize buyButton;
@synthesize cellIndex;
@synthesize dataObject;
@synthesize delegate;


#pragma mark Layout

- (void)layoutElements {
	[price positionAtY:([title bottomPosition] + 12)];
	[description positionAtY:([price bottomPosition] + 22)];
	
	CGFloat mdh = ([storeView height] - ([description yPosition] + (2 * [imageView yPosition]) + [buyButton height]));
	if ([description height] > mdh) {
		[description setHeight:mdh];
	}
}

#pragma mark Initialization

- (void)initializeView {
	CGRect r = self.contentView.bounds;
	r.size.height -= 90;
	storeView = [[UIView alloc] initWithFrame:r];
	[storeView setBackgroundColor:[UIColor whiteColor]];
	[self.contentView addSubview:storeView];
	[storeView centerInSuperView];
	
	[imageView removeFromSuperview];
	CGFloat m = 10;
	CGFloat h = [storeView height];
	CGFloat height = (h - (2 * m));
	CGFloat width = ((300 * height) / 400);
	[imageView setFrame:CGRectMake(m, m, width, height)];
	[storeView addSubview:imageView];
	
	UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[coverButton setFrame:imageView.frame];
	[coverButton addTarget:self action:@selector(didClickCoverImageButton:) forControlEvents:UIControlEventTouchUpInside];
	[coverButton setBackgroundColor:[UIColor clearColor]];
	[storeView addSubview:coverButton];
	
	CGFloat x = ([imageView rightPosition] + (2 * m));
	
	r = CGRectMake(x, m, ([storeView width] - (x + m)), 44);
	title = [[UILabel alloc] initWithFrame:r];
	[title setTextColor:[UIColor darkTextColor]];
	[title setNumberOfLines:2];
	[title setBackgroundColor:[UIColor clearColor]];
	[title setFont:[UIFont boldSystemFontOfSize:14]];
	[storeView addSubview:title];
	//[self setTitleText:@"Lorem ipsum dolor sit amet"];
	
	r = CGRectMake(x, ([storeView height] - m - 34), 100, 34);
	buyButton = [[UIButton alloc] initWithFrame:r];
	[buyButton addTarget:self action:@selector(didClickActionButton:) forControlEvents:UIControlEventTouchUpInside];
	[buyButton setBackgroundColor:[UIColor clearColor]];
	[buyButton setTitle:FTLangGet(@"Read") forState:UIControlStateNormal];
	[buyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	UIImage *image = [[UIImage imageNamed:@"MP_button-yellow.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
	[buyButton setBackgroundImage:image forState:UIControlStateNormal];
	[buyButton setTitleColor:[UIColor colorWithRealRed:67 green:47 blue:7 alpha:1] forState:UIControlStateNormal];
	[storeView addSubview:buyButton];
	
	r = title.frame;
	r.origin.y = ([title bottomPosition] + m);
	r.size.height = 16;
	price = [[UILabel alloc] initWithFrame:r];
	[price setTextColor:[UIColor grayColor]];
	[price setNumberOfLines:1];
	[price setBackgroundColor:[UIColor clearColor]];
	[price setFont:[UIFont systemFontOfSize:12]];
	[storeView addSubview:price];
	//[self setPriceText:@"£2.99"];
	
	description = [[UILabel alloc] initWithFrame:r];
	[description setTextColor:[UIColor grayColor]];
	[description setNumberOfLines:0];
	[description setBackgroundColor:[UIColor clearColor]];
	[description setFont:[UIFont systemFontOfSize:12]];
	[storeView addSubview:description];
	//[self setDescriptionText:@""];
}

#pragma mark Actions

- (void)didClickActionButton:(UIButton *)sender {
	if ([delegate respondsToSelector:@selector(didClickActionButtonWithIndex:andObject:)]) {
		[delegate didClickActionButtonWithIndex:cellIndex andObject:dataObject];
	}
}

- (void)didClickCoverImageButton:(UIButton *)sender {
	if ([delegate respondsToSelector:@selector(didClickCoverImageWithIndex:andObject:)]) {
		[delegate didClickCoverImageWithIndex:cellIndex andObject:dataObject];
	}
}

#pragma mark Setting text values

- (void)setTitleText:(NSString *)text {
	[title setText:text withWidth:title.frame.size.width];
	[self layoutElements];
}

- (void)setPriceText:(NSString *)text {
	[price setText:text];
	//[self layoutElements];
}

- (void)setDescriptionText:(NSString *)text {
	[description setText:text withWidth:description.frame.size.width];
	[self layoutElements];
}

#pragma mark Memory management

- (void)dealloc {
	[storeView release];
	[title release];
	[description release];
	[price release];
	[buyButton release];
	[dataObject release];
	[super dealloc];
}


@end
