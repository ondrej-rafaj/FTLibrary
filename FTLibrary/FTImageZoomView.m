//
//  FTImageZoomView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 07/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImageZoomView.h"


@implementation FTImageZoomView

@synthesize imageView;
@synthesize zoomDelegate;


#pragma mark Layout

- (void)doZoomLayout {
	if (imageView.image) {
		if (maxA == 0) {
			
		}
		if (maxB == 0) {
			
		}
		if (self.zoomScale > 0) {
			NSLog(@"Zoom apply");
		}
	}
}

#pragma mark Initialization

- (void)doImageZoomViewSetup {
	int imageWidth = [(UIImageView *)zoomedView image].size.width;
	int zoomWidth = self.frame.size.width;
	int max = imageWidth / zoomWidth;
	if (max < [self minimumZoomScale]) max = [self minimumZoomScale];
	[self setMaximumZoomScale:(max + 10)];
	[self doZoomLayout];
}

- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin {
	return nil;
}

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame {
	// Basic margin
	margin = 10;
	maxA = 0;
	maxB = 0;
	
	// Creating view
	FTImageView *v = [[FTImageView alloc] initWithImage:image];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[v setContentMode:UIViewContentModeScaleAspectFit];
	[v setDelegate:self];
	CGRect r = v.frame;
	r.size = frame.size;
	[v setFrame:r];
    self = [super initWithView:v andOrigin:frame.origin];
	//[self setImageView:v];
	[v release];
    if (self) {
        [self doImageZoomViewSetup];
    }
    return self;
}

#pragma mark Settings

- (void)setImage:(UIImage *)image {
	if (!zoomedView) {
		FTImageView *v = [[FTImageView alloc] initWithImage:image];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[v setContentMode:UIViewContentModeScaleAspectFit];
		[v setDelegate:self];
		CGRect r = v.frame;
		r.size = self.frame.size;
		[v setFrame:r];
		[super addZoomedView:v];
		[self setImageView:v];
		[v release];
	}
	else [(FTImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
}

- (void)loadImageFromUrl:(NSString *)url {
	if (!zoomedView) {
		FTImageView *v = [[FTImageView alloc] initWithFrame:self.bounds];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[v setContentMode:UIViewContentModeScaleAspectFit];
		[v setDelegate:self];
		CGRect r = v.frame;
		r.size = self.frame.size;
		[v setFrame:r];
		[super addZoomedView:v];
		[self setImageView:v];
		[v release];
	}
	[(FTImageView *)zoomedView loadImageFromUrl:url];
}

#pragma mark Positioning

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self doImageZoomViewSetup];
}

- (void)setSideMargin:(CGFloat)sideMargin {
	
}

#pragma mark Scrollview delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self doZoomLayout];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self doZoomLayout];
}

#pragma mark Image view delegate

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	[(FTImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
	if ([zoomDelegate respondsToSelector:@selector(imageZoomViewDidFinishLoadingImage:)]) {
		[zoomDelegate imageZoomViewDidFinishLoadingImage:self];
	}
}

- (void)imageViewDidFailLoadingImage:(FTImageView *)imgView withError:(NSError *)error {
	
}

- (void)imageViewDidStartLoadingImage:(FTImageView *)imgView {
	
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
    [super dealloc];
}


@end
