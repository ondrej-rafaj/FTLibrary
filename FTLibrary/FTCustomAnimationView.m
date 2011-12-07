//
//  FTCustomAnimationView.m
//  FTLibrary
//
//  Created by Baldoph Pourprix on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FTCustomAnimationView.h"

/*********************************** FTCustomAnimation ***********************************/

@interface FTCustomAnimation ()
@property (nonatomic, assign) NSTimeInterval startTimestamp;
@end

@implementation FTCustomAnimation

@synthesize key = _key;
@synthesize customProgressForTime = _customProgressForTime;
@synthesize disableUserInteraction = _disableUserInteraction;
@synthesize animationCurve = _animationCurve;
@synthesize duration = _duration;
@synthesize startTimestamp = _startTimestamp;

- (id)init
{
	self = [super init];
	if (self) {
		_key = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
		_disableUserInteraction = NO;
		_animationCurve = FTCustomAnimationCurveEaseInOut;
		_duration = 0.3;
	}
	return self;
}

- (void)dealloc
{
	[_key release];
	Block_release(_customProgressForTime);
	[super dealloc];
}

@end

/*********************************** FTCustomAnimationView ***********************************/

@interface FTCustomAnimationView ()
- (float)_progressForTime:(float)time andAnimationCurve:(FTCustomAnimationCurve)animationCurve;
- (void)_removeAnimations:(NSArray *)animations;
@end

@implementation FTCustomAnimationView

#pragma mark - private

- (float)_progressForTime:(float)time andAnimationCurve:(FTCustomAnimationCurve)animationCurve
{
	switch (animationCurve) {
		case FTCustomAnimationCurveEaseInOut:
			return atanf(3.009569674f * time) / 1.25f;
			break;
		case FTCustomAnimationCurveLinear:
			return time;
			break;
	}
	return 0.f;
}

- (void)_displayLinkDidFire
{
	[self setNeedsDisplay];
}

- (void)_removeAnimations:(NSArray *)animations
{
	for (FTCustomAnimation *anim in animations) {
		[_animations removeObject:anim];
		[self animationDidFinish:anim];
	}
	if (_animations.count == 0) { 
		_displayLink.paused = YES;
		_isAnimating = NO;
	}
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_animations = [NSMutableArray new];
		_displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(_displayLinkDidFire)] retain];
		_displayLink.paused = YES;
		_displayLink.frameInterval = 2;
		[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		_isAnimating = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	NSMutableArray *animsToDelete = [NSMutableArray new];
	for (FTCustomAnimation *anim in _animations) {
		float progress = 1.f;
		if (_isAnimating) {
			NSTimeInterval durationSinceBeginning = [[NSDate date] timeIntervalSince1970] - anim.startTimestamp;
			NSTimeInterval time = durationSinceBeginning / anim.duration;
			if (anim.customProgressForTime) {
				progress = anim.customProgressForTime(time);
			}
			else {
				progress = [self _progressForTime:time andAnimationCurve:anim.animationCurve];
				if (progress >= 1) [animsToDelete addObject:anim];
			}
		}
		[self drawRect:rect forAnimation:anim withAnimationProgress:progress];
	}
	if (_animations.count == 0) {
		[self drawRect:rect forAnimation:nil withAnimationProgress:1];
	}
	if (animsToDelete.count > 0) [self _removeAnimations:animsToDelete];
}

- (void)drawRect:(CGRect)rect forAnimation:(FTCustomAnimation *)animation withAnimationProgress:(float)progress
{
	
}

- (void)dealloc
{
	[_displayLink invalidate];
	[_displayLink release];
	[_animations release];
	[super dealloc];
}

#pragma mark - Animations

- (void)setNeedsDisplayNotAnimated
{
	
	[self setNeedsDisplay];
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
	FTCustomAnimation *animation = [FTCustomAnimation new];
	animation.duration = duration;
	[self addAnimation:animation];
}

- (void)addAnimation:(FTCustomAnimation *)animation
{
	[self insertAnimation:animation atIndex:_animations.count];
}

- (void)insertAnimation:(FTCustomAnimation *)animation belowAnimation:(FTCustomAnimation *)otherAnimation
{
	NSInteger otherAnimIndex = [_animations indexOfObject:otherAnimation];
	if (otherAnimIndex == NSNotFound) {
		[self addAnimation:animation];
	}
	else {
		[self insertAnimation:animation atIndex:otherAnimIndex];
	}
}

- (void)insertAnimation:(FTCustomAnimation *)animation aboveAnimation:(FTCustomAnimation *)otherAnimation
{
	NSInteger otherAnimIndex = [_animations indexOfObject:otherAnimation];
	if (otherAnimIndex == NSNotFound) {
		[self addAnimation:animation];
	}
	else {
		[self insertAnimation:animation atIndex:otherAnimIndex + 1];
	}
}

- (void)insertAnimation:(FTCustomAnimation *)animation atIndex:(NSInteger)index
{
	animation.startTimestamp = [[NSDate date] timeIntervalSince1970];
	[_animations insertObject:animation atIndex:index];
	[self animationWillBegin:animation];
	if (_displayLink.paused) {
		_isAnimating = YES;
		_displayLink.paused = NO;
	}
}

#pragma mark - Animations 'callbacks'

- (void)animationWillBegin:(FTCustomAnimation *)animation
{
	
}

- (void)animationDidFinish:(FTCustomAnimation *)animation
{
	
}

@end