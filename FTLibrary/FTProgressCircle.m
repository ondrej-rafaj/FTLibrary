//
//  FTProgressCircle.m
//  FTLibrary
//
//  Created by Francesco on 21/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTProgressCircle.h"
#import <QuartzCore/QuartzCore.h>

@implementation FTProgressCircle

@synthesize foregroundImage = _foregroundImage;
@synthesize percentage = _percentage;
@synthesize shouldAnimate = _shouldAnimate;
@synthesize fromValue = _fromValue;


#pragma mark setters

- (void)setDegrees:(CGFloat)degrees animated:(BOOL)animated {
    float perc = (degrees * 3.6);
    [self setPercentage:perc animated:animated];
}

- (void)setPercentage:(CGFloat)percentage animated:(BOOL)animated {
    self.fromValue = _percentage;
    _percentage = percentage;
    self.shouldAnimate = YES;
    [self setNeedsDisplay];
}

- (void)setPercentage:(CGFloat)percentage {
    [self setPercentage:percentage animated:NO];
}




- (id)initWithBackgroundImage:(UIImage *)bkgImg andForegroundImage:(UIImage *)frgImg {
    self = [super initWithFrame:CGRectMake(0, 0, bkgImg.size.width, bkgImg.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:bkgImg]];
        
        self.foregroundImage = frgImg;
        [self setPercentage:0];
    }
    return self;    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    CGFloat percRadians = ((self.percentage  / 3.6) * (2 * M_PI));
    CGFloat radius = (self.bounds.size.width / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:-90 endAngle:percRadians clockwise:YES];
    [path applyTransform:CGAffineTransformMakeRotation((-90 * (2 * M_PI)))];
    

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddPath(arcPath, 0, path.CGPath);
    CGContextAddPath(context, arcPath);
    CGContextClip(context);

    CFRelease(arcPath);
    

    [self.foregroundImage drawInRect:self.frame];
    CGContextRestoreGState(context);
    
    [[UIColor blueColor] setStroke];
    [path stroke];

}


- (void)dealloc {
    
    [_foregroundImage release], _foregroundImage = nil;
    [super dealloc];
}


@end
