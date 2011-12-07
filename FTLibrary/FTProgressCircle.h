//
//  FTProgressCircle.h
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCustomAnimationView.h"

@interface FTProgressCircle : FTCustomAnimationView {
    UIImage *_foregroundImage;
	UIImage *_backgroundImage;
	CGPoint _circleCenter;
    int _percentage;
    BOOL _outlinePath;
	float _startValue;
	float _difference;
}

@property (nonatomic, assign) int percentage;
@property (nonatomic, assign) BOOL outlinePath;
@property (nonatomic, assign) NSTimeInterval speed; //speed is in number of loop per second

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg;
- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg andCircleCenter:(CGPoint)center;

- (NSTimeInterval)setPercentage:(int)percentage animated:(BOOL)animated;
- (NSTimeInterval)setPercentage:(int)percentage fromPercentage:(int)fromPercentage animated:(BOOL)animated;

- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated;

@end
