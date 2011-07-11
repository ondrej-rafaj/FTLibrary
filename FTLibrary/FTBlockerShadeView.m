//
//  FTBlockerShadeView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 11/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTBlockerShadeView.h"
#import "FTAppDelegate.h"


@implementation FTBlockerShadeView


#pragma mark Color & animations

- (UIColor *)colorForAlpha:(CGFloat)alpha {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}

#pragma mark Initialization

- (void)doInit {
	[self setBackgroundColor:[self colorForAlpha:0]];
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
	 
#pragma mark Display methods

- (void)show:(BOOL)animated {
	isAnimated = animated;
	UIWindow *w = [FTAppDelegate window];
    
}

- (void)show {
	[self show:NO];
}

- (void)hide {
	
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end
