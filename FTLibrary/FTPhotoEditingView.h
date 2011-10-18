//
//  FTPhotoEditingView.h
//  xProgress.com
//
//  Created by Ondrej Rafaj on 11/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPhotoEditingElementView.h"


@class FTPhotoEditingView;

@protocol FTPhotoEditingViewDelegate <NSObject>

- (void)cropView:(FTPhotoEditingView *)view didMoveDDCTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

@end


@interface FTPhotoEditingView : UIView {
    
    FTPhotoEditingElementView *ddTopLeft;
    FTPhotoEditingElementView *ddTopRight;
    FTPhotoEditingElementView *ddBottomLeft;
    FTPhotoEditingElementView *ddBottomRight;
    
    id <FTPhotoEditingViewDelegate> delegate;
	
	UIImage *_originalImage;
    UIImage *_resizedImage;
    CGSize _originalImageSize;
	
	BOOL _isBlackAndWhite;
	BOOL _isCropEnabled;
	
}

@property (nonatomic, assign) id <FTPhotoEditingViewDelegate> delegate;

- (void)manualUpdate;

- (void)setImage:(UIImage *)image;

- (void)resetCropZone;

- (void)toggleBlackAndWhite;
- (BOOL)isBlackAndWhite;

- (void)toggleCropImage;
- (BOOL)isCroppingEnabled;

- (UIImage *)image;


@end
