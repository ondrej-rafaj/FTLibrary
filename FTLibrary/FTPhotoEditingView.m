//
//  FTPhotoEditingView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 30/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTPhotoEditingView.h"

@implementation FTPhotoEditingView


#pragma mark Creating elements

- (void)createZoomView {
	
}

- (void)createImageView {
	
}

- (void)createCroppingRectangle {
	
}

- (void)createAllElements {
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

@end
