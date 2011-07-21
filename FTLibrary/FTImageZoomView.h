//
//  FTImageZoomView.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 07/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTZoomView.h"
#import "FTImageView.h"


@class FTImageZoomView;

@protocol FTImageZoomViewDelegate <NSObject>

- (void)imageZoomViewDidFinishLoadingImage:(FTImageZoomView *)zoomView;

@end


@interface FTImageZoomView : FTZoomView <FTImageViewDelegate> {
	
	FTImageView *imageView;
	
	id <FTImageZoomViewDelegate> zoomDelegate;
	
	CGFloat margin;
	
	CGFloat maxA;
	CGFloat maxB;
	
}

@property (nonatomic, retain) FTImageView *imageView;

@property (nonatomic, assign) id <FTImageZoomViewDelegate> zoomDelegate;


- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin;

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame;

- (void)setImage:(UIImage *)image;

- (void)loadImageFromUrl:(NSString *)url;

- (void)setSideMargin:(CGFloat)sideMargin;


@end