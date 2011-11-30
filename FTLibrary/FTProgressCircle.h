//
//  FTProgressCircle.h
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTProgressCircle : UIView {
    UIImage *_foregroundImage;
	UIImage *_backgroundImage;
	CGPoint _circleCenter;
    int _percentage;
    BOOL _outlinePath;
    float _animationDuration;
@private
    BOOL _shouldAnimate;
    int _fromValue;
    CADisplayLink *_displayLink;
    NSInteger _frameInterval;
}

@property (nonatomic, retain) IBOutlet UIImage *foregroundImage;
@property (nonatomic, assign) int percentage;
@property (nonatomic ,assign) BOOL outlinePath;
@property (nonatomic, assign) float animationDuration;
@property (nonatomic, assign, getter=isShouldAnimate) BOOL shouldAnimate;
@property (nonatomic, assign) int fromValue;
@property (nonatomic, retain) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger frameInterval;

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg;
- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg andCircleCenter:(CGPoint)center;
- (void)animateToPercentage:(int)percentage;
- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated;
@end
