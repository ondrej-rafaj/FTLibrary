//
//  FTDummyPage.m
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDummyPage.h"
#import "UIView+Layout.h"
#import "UIColor+Tools.h"


@implementation FTDummyPage


#pragma mark Initialization

- (id)init {
	self = [super initWithFrame:CGRectMake(0, 0, 1024, 748)];
	if (self) {
		[self setBackgroundColor:[UIColor randomColor]];
	}
	return self;	
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
		[iv setContentMode:UIViewContentModeScaleToFill];
		[iv setImage:image];
		[self addSubview:iv];
		[iv release];
	}
	return self;
}


@end
