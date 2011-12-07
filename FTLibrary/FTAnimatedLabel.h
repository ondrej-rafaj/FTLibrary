//
//  FTAnimatedNumberLabel.h
//  Fuerte International
//
//  Created by cescofry on 25/03/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLabel.h"


@interface FTAnimatedLabel : FTLabel {
    NSInteger _value;
    NSInteger _endValue;
    NSTimeInterval _duration;
    BOOL _shouldAddPercentSign;
@private
    CADisplayLink *_displayLink;
    NSInteger _stepValue;
    NSInteger _frameInterval;
}

@property(nonatomic) NSInteger value;
@property(nonatomic) NSInteger endValue;
@property(nonatomic) NSTimeInterval duration;
@property(nonatomic) BOOL shouldAddPercentSign;
@property(nonatomic) NSInteger stepValue;
@property(nonatomic) NSInteger frameInterval;
@property(nonatomic, retain) CADisplayLink *displayLink;


- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andEndValue:(NSInteger)value;

- (void)animate;
- (void)animateToValue:(NSInteger)aValue;
- (void)animateFromValue:(NSInteger)fromValue toValue:(NSInteger)toValue;
- (void)stepToValue:(NSInteger)aValue;


@end
