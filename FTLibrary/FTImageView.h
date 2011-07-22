//
//  FTImageView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class FTImageView;

@protocol FTImageViewDelegate <NSObject>

@optional

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image;

- (void)imageViewDidFailLoadingImage:(FTImageView *)imgView withError:(NSError *)error;

- (void)imageViewDidStartLoadingImage:(FTImageView *)imgView;

@end


@interface FTImageView : UIImageView {
    
    UIImageView *overlayImage;
	
	UIView *flashOverlay;
	
	id <FTImageViewDelegate> delegate;
	
	UIActivityIndicatorView *activityIndicator;
	
	UIProgressView *progressLoadingView;
		
	BOOL debugMode;
	UILabel *debugLabel;
	
	NSString *imageUrl;
    
}

@property (nonatomic, retain) UIImageView *overlayImage;

@property (nonatomic, assign) id <FTImageViewDelegate> delegate;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIProgressView *progressLoadingView;

@property (nonatomic, readonly) BOOL debugMode;

@property (nonatomic, readonly) NSString *imageUrl;


- (id)initWithFrameWithRandomColor:(CGRect)frame;
- (void)setRandomColorBackground;

- (void)doFlashWithColor:(UIColor *)color;

- (void)loadImageFromUrl:(NSString *)url;

//- (void)enableProgressLoadingView:(BOOL)enable;

- (void)enableActivityIndicator:(BOOL)enable;

- (void)enableDebugMode:(BOOL)debugMode;


@end
