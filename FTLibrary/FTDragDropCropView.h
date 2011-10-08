//
//  FTDragDropCropView.h
//  xProgress.com
//
//  Created by Ondrej Rafaj on 11/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDragDropCropElementView.h"


@class FTDragDropCropView;

@protocol FTDragDropCropViewDelegate <NSObject>

- (void)cropView:(FTDragDropCropView *)view didMoveDDCTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

@end


@interface FTDragDropCropView : UIView {
    
    FTDragDropCropElementView *ddTopLeft;
    FTDragDropCropElementView *ddTopRight;
    FTDragDropCropElementView *ddBottomLeft;
    FTDragDropCropElementView *ddBottomRight;
    
    id <FTDragDropCropViewDelegate> delegate;
	
	UIImage *_originalImage;
    UIImage *_resizedImage;
    CGSize _originalImageSize;
	
	BOOL _isBlackAndWhite;
	BOOL _isCropEnabled;
	
}

@property (nonatomic, assign) id <FTDragDropCropViewDelegate> delegate;

- (void)manualUpdate;

- (void)setImage:(UIImage *)image;

- (void)resetCropZone;

- (void)toggleBlackAndWhite;
- (BOOL)isBlackAndWhite;

- (void)toggleCropImage;
- (BOOL)isCroppingEnabled;

- (UIImage *)image;


@end
