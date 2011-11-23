//
//  FTAnimatedNumberLabel.h
//  Regaine
//
//  Created by cescofry on 25/03/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLabel.h"


@interface FTAnimatedNumberLabel : FTLabel {
    NSInteger _value;
    NSInteger _endValue;
    NSTimeInterval _duration;
    BOOL _shouldAddPercentSign;
@private
    NSInteger _stepValue;
    NSTimer *_timer;
}

@property(nonatomic) NSInteger value;
@property(nonatomic) NSInteger endValue;
@property(nonatomic) NSTimeInterval duration;
@property(nonatomic) BOOL shouldAddPercentSign;
@property(nonatomic) NSInteger stepValue;
@property(nonatomic, retain) NSTimer *timer;

- (void)animate;
- (void)animateToValue:(NSInteger)aValue;
- (id)initWithFrame:(CGRect)frame font:(UIFont *)font andEndValue:(NSInteger)value;

@end
