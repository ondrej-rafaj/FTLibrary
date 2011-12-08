//
//  FTProgressCircle.m
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTProgressCircle.h"
#import "FTMath.h"

@implementation FTProgressCircle

@synthesize percentage = _percentage;
@synthesize outlinePath = _outlinePath;
@synthesize speed = _speed;

#pragma mark setters

- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated
{
    float perc = degrees / 3.6f;
	[self setPercentage:perc animated:animated];
}

- (void)setPercentage:(int)percentage
{
	[self setPercentage:percentage animated:NO];
}

- (NSTimeInterval)setPercentage:(int)percentage animated:(BOOL)animated
{
	return [self setPercentage:percentage fromPercentage:0 animated:animated];
}

- (NSTimeInterval)setPercentage:(int)percentage fromPercentage:(int)fromPercentage animated:(BOOL)animated
{
	_percentage = percentage;
	_startValue = fromPercentage;
	_difference = percentage - fromPercentage;
	if (animated && !self.isAnimating) {
		NSTimeInterval animationDuration = fabs(( _difference / 100) / _speed);
		[self startAnimationWithDuration:animationDuration];
		return animationDuration;
	}
	else {
		[self setNeedsDisplay];
		return 0.0;
	}
}

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg
{
	return [self initWithBackgroundImage:bkgImg andForegroundImage:frgImg andCircleCenter:CGPointMake(bkgImg.size.width / 2.f, bkgImg.size.height / 2.f)];
}

- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg andCircleCenter:(CGPoint)center
{
	self = [super initWithFrame:CGRectMake(0, 0, bkgImg.size.width, bkgImg.size.height)];
    if (self) {
        // Initialization code
		self.opaque = NO;
		_circleCenter = center;
		_backgroundImage = [bkgImg retain];
        _foregroundImage = [frgImg retain];
        [self setPercentage:0];
        self.outlinePath = NO;
		_difference = 0;
		_speed = 1;
    }
    return self; 
}


- (void)drawRect:(CGRect)rect forAnimation:(FTCustomAnimation *)animation withAnimationProgress:(float)progress
{
	CGContextRef context = UIGraphicsGetCurrentContext();

    float degrees = (_startValue + _difference * progress) * 3.6;
    float percRadians = toRad((int)(degrees - 90));
	float radius = (self.bounds.size.width / 2);
    
    UIBezierPath *foregroundTrackPath = [UIBezierPath bezierPath];
    [foregroundTrackPath moveToPoint:_circleCenter];
    [foregroundTrackPath addLineToPoint:CGPointMake(_circleCenter.x, 0)];
    [foregroundTrackPath addArcWithCenter:_circleCenter radius:radius startAngle:toRad(-90) endAngle:percRadians clockwise:YES];
    [foregroundTrackPath closePath];
    //[path applyTransform:CGAffineTransformMakeRotation(toRad(-90))];
    
	UIBezierPath *backgroundTrackPath = [UIBezierPath bezierPath];
    [backgroundTrackPath moveToPoint:_circleCenter];
    [backgroundTrackPath addLineToPoint:CGPointMake(_circleCenter.x, 0)];
    [backgroundTrackPath addArcWithCenter:_circleCenter radius:radius startAngle:3 * M_PI / 2 endAngle:percRadians clockwise:NO];
    [backgroundTrackPath closePath];

    CGContextSaveGState(context);
    CGMutablePathRef arcBackgroundArc = CGPathCreateMutable();
    CGPathAddPath(arcBackgroundArc, 0, backgroundTrackPath.CGPath);
    CGContextAddPath(context, arcBackgroundArc);
    CGContextClip(context);
	
    CFRelease(arcBackgroundArc);
    
    [_backgroundImage drawInRect:self.frame];
    
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddPath(arcPath, 0, foregroundTrackPath.CGPath);
    CGContextAddPath(context, arcPath);
    CGContextClip(context);

    CFRelease(arcPath);
    
    [_foregroundImage drawInRect:self.frame];
    
    CGContextRestoreGState(context);

    if (self.outlinePath) {
        [[UIColor blueColor] setStroke];
        [foregroundTrackPath stroke];        
    }
}


- (void)dealloc {
    
    [_foregroundImage release], _foregroundImage = nil;
    [super dealloc];
}


@end
