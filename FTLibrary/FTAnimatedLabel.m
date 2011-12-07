//
//  FTAnimatedNumberLabel.m
//  Fuerte International
//
//  Created by cescofry on 25/03/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAnimatedLabel.h"
#import <QuartzCore/QuartzCore.h>


@interface FTAnimatedLabel ()

@property (nonatomic) NSTimeInterval timerSteps; 

@end


@implementation FTAnimatedLabel

@synthesize value = _value;
@synthesize endValue = _endValue;
@synthesize duration = _duration;
@synthesize shouldAddPercentSign = _shouldAddPercentSign;
@synthesize stepValue = _stepValue;
@synthesize timerSteps = _timerSteps;
@synthesize displayLink = _displayLink;
@synthesize frameInterval = _frameInterval;

- (void)updateValue {
    NSString *format = (self.shouldAddPercentSign)? @"%.2d%%" : @"%.2d";
    [self setText:[NSString stringWithFormat:format,self.value]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextAlignment:UITextAlignmentRight];
        self.value = 0;
        self.endValue = 100;
        self.duration = 0.6;
        self.stepValue = 2;
        [self updateValue];
        self.shouldAddPercentSign = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andEndValue:(NSInteger)aValue {
    self = [super initWithFrame:frame font:font andText:@"00"];
    if (self) {
        self.endValue = aValue;
    }
    return self;    
}

- (void)doAnimation:(CADisplayLink *)link {
    if ((self.frameInterval == 0) && (link.duration > 0.0) && (self.duration > 0.0)) {
        int fr = (self.duration / link.duration);
        self.frameInterval = MAX(1, ceil(fr / (int)self.endValue));
        [link setFrameInterval:self.frameInterval];
    }
    self.value += 1;
    
    if (self.value >= self.endValue) {
        self.value = self.endValue;
		_displayLink.paused = YES;
    }
    [self updateValue];
}

- (void)animate {
    [self animateToValue:self.endValue];
}

- (void)animateFromValue:(NSInteger)fromValue toValue:(NSInteger)toValue {
    self.value = fromValue;
    [self animateToValue:toValue];
}

- (void)animateToValue:(NSInteger)aValue {
    self.endValue = aValue;
    
    //reset value 
    if (_displayLink == nil) { 
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(doAnimation:)];
		[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	self.displayLink.paused = NO;
    [self doAnimation:self.displayLink];
    
}

- (void)stepToValue:(NSInteger)aValue {
    self.endValue = self.value = aValue;
    [self updateValue];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_displayLink invalidate], _displayLink = nil;
    [super dealloc];
}

@end
