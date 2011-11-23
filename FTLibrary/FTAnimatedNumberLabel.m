//
//  FTAnimatedNumberLabel.m
//  Regaine
//
//  Created by cescofry on 25/03/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAnimatedNumberLabel.h"


@interface FTAnimatedNumberLabel ()

@property (nonatomic) NSTimeInterval timerSteps; 

@end


@implementation FTAnimatedNumberLabel

@synthesize value = _value;
@synthesize endValue = _endValue;
@synthesize duration = _duration;
@synthesize shouldAddPercentSign = _shouldAddPercentSign;
@synthesize stepValue = _stepValue;
@synthesize timerSteps = _timerSteps;
@synthesize timer = _timer;

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
        self.duration = 2;
        self.stepValue = 1;
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



- (void)addCount {
    self.value = ((self.value + self.stepValue) > self.endValue)? self.endValue : (self.value + self.stepValue);      
    if(self.value <= self.endValue)[self updateValue];
    if(self.value == self.endValue) [self.timer invalidate];
}


- (void)animate {
    [self animateToValue:self.endValue];
}

- (void)animateToValue:(NSInteger)aValue {
    self.endValue = aValue;
    
    //reset value 
    if(self.value >= self.endValue) self.value = 0;
    self.timerSteps = self.duration / ((self.endValue - self.value) / self.stepValue);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerSteps target:self selector:@selector(addCount) userInfo:nil repeats:YES];
    [self.timer fire];
}


- (void)startAnimation {
    //reset value 
    if(self.value == self.endValue) self.value = 0;
    self.timerSteps = self.duration / ((self.endValue - self.value) / self.stepValue);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerSteps target:self selector:@selector(addCount) userInfo:nil repeats:YES];
    [self.timer fire];
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
    if(self.timer) [self.timer invalidate];
    [_timer release], _timer = nil;
    [super dealloc];
}

@end
