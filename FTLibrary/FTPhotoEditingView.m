//
//  FTPhotoEditingView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 30/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTPhotoEditingView.h"
#import "UIColor+Tools.h"


@implementation FTPhotoEditingView


#pragma mark Creating elements

- (void)createZoomView {
	zoomView = [[UIScrollView alloc] initWithFrame:self.bounds];
	[zoomView setBounces:NO];
	[zoomView setDelegate:self];
	[zoomView setBackgroundColor:[UIColor clearColor]];
	[zoomView setAutoresizesSubviews:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[zoomView setMaximumZoomScale:2.5];
	[self addSubview:zoomView];
}

- (void)createImageView {
	imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[imageView setBackgroundColor:[UIColor clearColor]];
	[imageView setAutoresizesSubviews:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	[zoomView addSubview:imageView];
}

- (void)createCroppingRectangle {
	
}

- (void)createAllElements {
	// Configuration
	[self setBackgroundColor:[UIColor alphaPatternImageColor]];
	
	// Creating elements
	[self createZoomView];
	[self createImageView];
	[self createCroppingRectangle];
}

#pragma mark Initialization

- (void)initializeView {
	[self createAllElements];
}

#pragma mark Image settings

- (void)setImage:(UIImage *)image {
	[imageView setImage:image];
}

- (UIImage *)image {
	return nil;
}

#pragma mark Crop settings

- (void)enableCropping:(BOOL)enabled withTopLeftCornerButton:(UIImage *)topLeft withTopRight:(UIImage *)topRight withBottomLeft:(UIImage *)bottomLeft andBottomRight:(UIImage *)bottomRight {
	
}

- (void)enableCropping:(BOOL)enabled withCornerButtons:(UIImage *)buttonImage {
	
}

- (void)enableCropping:(BOOL)enabled {
	
}

- (void)enableCroppingMask:(BOOL)enabled {
	
}

#pragma mark Zoom settings

- (void)enableZoom:(BOOL)enabled withMaxZoomScale:(CGFloat)maxZoomScale {
	
}

- (void)enableZoom:(BOOL)enabled {
	
}

#pragma mark Zoom delegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGSize fullSize = CGSizeMake(imageView.image.size.width, imageView.image.size.height);
    
	CGFloat oldWidth = self.size.width;
	CGFloat oldHeight = self.size.height;
	CGFloat newWidth = fullSize.width;
	CGFloat newHeight = (oldHeight * newWidth) / oldWidth;
	if (newHeight > fullSize.height) {
		newWidth = (newWidth * fullSize.height) / newHeight;
		newHeight = fullSize.height;
	}
	
	//CGRect newRect = CGRectMake(0, 0, newWidth, newHeight);
	
	
	//CGPoint leftBoundary = scrollView.contentOffset;
	//CGPoint rightBoundary = scrollView.contentOffset;
}

#pragma mark Memory management

- (void)dealloc {
	[zoomView release];
	[imageView release];
	[_topLeftCroppingImage release];
	[_topRightCroppingImage release];
	[_bottomLeftCroppingImage release];
	[_bottomRightCroppingImage release];
	[super dealloc];
}


@end
