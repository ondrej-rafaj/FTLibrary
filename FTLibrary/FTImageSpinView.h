//
//  FTImageSpinView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTImageSpinView : UIView <UIScrollViewDelegate> {
    
	NSMutableArray *imageNames;
	
	UIImageView *imageCanvas;
	
	UIScrollView *scrollView;
	
	int currentIndex;
	int currentOffset;
	
	CGFloat animationSpeed;
	
	BOOL isReverse;
	
	BOOL debugMode;
	UILabel *debugLabel;
	
}

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, readonly) int currentIndex;

@property (nonatomic) CGFloat animationSpeed;

@property (nonatomic) BOOL isReverse;

@property (nonatomic) BOOL debugMode;


- (void)addImage:(NSString *)imagePath;

- (void)loadImagesWithFolderPath:(NSString *)folderPath withFormat:(NSString *)fileFormat withStartIndex:(int)startIndex andFinalIdex:(int)finalIndex;

- (void)loadImagesFromBundleWithFileFormat:(NSString *)format withStartIndex:(int)startIndex andFinalIdex:(int)finalIndex;

- (void)showIndex:(int)index withAnimationCurve:(UIViewAnimationCurve)animationCurve;

- (void)showIndex:(int)index animated:(BOOL)animated;

- (void)showIndex:(int)index;

- (UIImage *)imageAtIndex:(int)index;

- (void)setContentModeForImageCanvas:(UIViewContentMode)contentMode;

- (void)removeAllImages;


@end
