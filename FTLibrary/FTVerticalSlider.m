//
//  FTVerticalSlider.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 30/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTVerticalSlider.h"
//#import <QuartzCore/QuartzCore.h>


@implementation FTVerticalSlider

@synthesize orientation;

#pragma mark Positioning & layout

- (void)setFrame:(CGRect)frame {
	CGRect r = frame;
	r.size.width = frame.size.height;
	r.size.height = frame.size.width;
	[super setFrame:r];
}

#pragma mark Transformations

- (void)applyTransformation {
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 0.5);
	self.transform = transform;
}

#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
		[self applyTransformation];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self applyTransformation];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	CGRect r = frame;
	r.size.width = frame.size.height;
	r.size.height = frame.size.width;
	self = [super initWithFrame:frame];
	if (self) {
		[self applyTransformation];
		[self setFrame:r];
	}
	return self;
}

@end
