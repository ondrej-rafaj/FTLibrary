//
//  FTLabel.m
//  FTLibrary
//
//  Created by Francesco on 22/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLabel.h"
#import "UILabel+DynamicHeight.h"


@implementation FTLabel


#pragma Initialization

- (void)doInit {
	[self setBackgroundColor:[UIColor clearColor]];
	[self setLineBreakMode:UILineBreakModeWordWrap];
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andText:(NSString *)text {
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
	frame.size.height = textSize.height;
    self = [self initWithFrame:frame];
    if (self) {
        [self doInit];
		[self setNumberOfLines:0];
		[self setFont:font];
		[self setText:text];
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
