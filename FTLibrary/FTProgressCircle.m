//
//  FTProgressCircle.m
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTProgressCircle.h"
#import <QuartzCore/QuartzCore.h>
#import "FTMath.h"

@implementation FTProgressCircle

@synthesize foregroundImage = _foregroundImage;
@synthesize percentage = _percentage;
@synthesize outlinePath = _outlinePath;
@synthesize animationDuration = _animationDuration;
@synthesize shouldAnimate = _shouldAnimate;
@synthesize fromValue = _fromValue;
@synthesize displayLink = _displayLink;
@synthesize frameInterval = _frameInterval;

#pragma mark setters

- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated {
    float perc = (degrees * 3.6);
    if (animated) [self animateToPercentage:perc];
    else [self setPercentage:perc];
}

- (void)doAnimation:(CADisplayLink *)link {
    if ((self.frameInterval == 0) && (link.duration > 0.0) && (self.animationDuration > 0.0)) {
        int fr = (self.animationDuration / link.duration);
        self.frameInterval = MAX(1, ceil(fr / self.percentage));
        [link setFrameInterval:self.frameInterval];
    }
    self.fromValue += 1;
    
    if (self.fromValue >= self.percentage) {
        self.fromValue = self.percentage;
		_displayLink.paused = YES;
    }
    [self setNeedsDisplay];
}

- (void)animateToPercentage:(int)percentage {
    _percentage = percentage;
    self.fromValue = 0;
    if (_displayLink == nil) { self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(doAnimation:)];
		[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	_displayLink.paused = NO;
    [self doAnimation:self.displayLink];

}

- (void)setPercentage:(int)percentage {
    _percentage = percentage;
    self.fromValue = _percentage;
    [self setNeedsDisplay];
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
        self.foregroundImage = frgImg;
        [self setPercentage:0];
        self.outlinePath = NO;
        self.animationDuration = 0.8;
        self.frameInterval = 0;
    }
    return self; 
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

    float degrees =  (self.fromValue * 3.6);
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
    
    [self.foregroundImage drawInRect:self.frame];
    
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
