//
//  FTZoomView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 07/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTZoomView.h"


@implementation FTZoomView

@synthesize zoomedView;


#pragma mark Initialization

- (void)doZoomViewSetup {
	// Basic self settings
	[self setMinimumZoomScale:1.0];
	[self setMaximumZoomScale:4.0];
	
	[self setContentSize:self.frame.size];
	
	[super setDelegate:self];
	
	[self setBackgroundColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        [self doZoomViewSetup];
    }
    return self;
}

- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin {
	CGRect r = view.bounds;
	r.origin = origin;
    self = [super initWithFrame:r];
    if (self) {
        [self addZoomedView:view];
    }
    return self;
}

#pragma mark Settings

- (void)addZoomedView:(UIView *)view {
	[self setZoomedView:view];
	[self addSubview:zoomedView];
	[zoomedView setUserInteractionEnabled:NO];
	[self setContentSize:self.frame.size];
//	[self setContentSize:CGSizeMake(500, 500)];
}

#pragma mark Scroll view delegate methods

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
	// Disable set delegate method
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return zoomedView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	NSLog(@"Scroll zoom: %f", scrollView.zoomScale);
}

#pragma mark Memory management

- (void)dealloc {
	[zoomedView release];
    [super dealloc];
}

@end
