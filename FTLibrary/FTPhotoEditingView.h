//
//  FTPhotoEditingView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 30/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"


typedef enum {
	
	FTPhotoEditingViewCropLineStyleFull,
	FTPhotoEditingViewCropLineStyleDashed
	
} FTPhotoEditingViewCropLineStyle;


@interface FTPhotoEditingView : FTView <UIScrollViewDelegate> {
	
	UIScrollView *zoomView;
	UIImageView *imageView;
	
	FTPhotoEditingViewCropLineStyle _cropLineStyle;
	
	BOOL _croppingEnabled;
	UIImage *_topLeftCroppingImage;
	UIImage *_topRightCroppingImage;
	UIImage *_bottomLeftCroppingImage;
	UIImage *_bottomRightCroppingImage;
	BOOL _croppingMaskEnabled;
	
	BOOL _zoomEnabled;
	CGFloat _maxZoomScale;
	
}

- (void)setImage:(UIImage *)image;
- (UIImage *)image;

- (void)enableCropping:(BOOL)enabled withTopLeftCornerButton:(UIImage *)topLeft withTopRight:(UIImage *)topRight withBottomLeft:(UIImage *)bottomLeft andBottomRight:(UIImage *)bottomRight;
- (void)enableCropping:(BOOL)enabled withCornerButtons:(UIImage *)buttonImage;
- (void)enableCropping:(BOOL)enabled;
- (void)enableCroppingMask:(BOOL)enabled;

- (void)enableZoom:(BOOL)enabled withMaxZoomScale:(CGFloat)maxZoomScale;
- (void)enableZoom:(BOOL)enabled;


@end
