//
//  FTCustomAnimationView.h
//  FTLibrary
//
//  Created by Baldoph Pourprix on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	FTCustomAnimationCurveEaseInOut,
	FTCustomAnimationCurveEaseOut,
	FTCustomAnimationCurveLinear
} FTCustomAnimationCurve;

typedef NSUInteger FTCustomAnimationOptions;

@class CADisplayLink;
@class FTCustomAnimation;
@protocol FTCustomAnimationObserver;

@interface FTCustomAnimationView : UIView {
	
	CADisplayLink *_displayLink;
	NSMutableArray *_animations;
	int _disableToken;
	NSMutableArray *_animationObservers;
}

@property (nonatomic, assign) BOOL isAnimating;

//handy method to start an animation
- (void)startAnimationWithDuration:(NSTimeInterval)duration;
- (void)startAnimationWithDuration:(NSTimeInterval)duration andKey:(NSString *)key;

/* When you add an animation, the method -drawRect:forAnimation:withAnimationProgress: start being called for the
 * time of the animation's 'duration' property. The position you add your animation at will be the 
 * position you draw your content for this animation. That is if you insert an animation at the index 0, the
 * -drawRectMethod for this animation will be called first and the other animations' contents will be drawn over this
 * one. */

- (void)addAnimation:(FTCustomAnimation *)animation;
- (void)insertAnimation:(FTCustomAnimation *)animation atIndex:(NSInteger)index;
- (void)insertAnimation:(FTCustomAnimation *)animation belowAnimation:(FTCustomAnimation *)otherAnimation;
- (void)insertAnimation:(FTCustomAnimation *)animation aboveAnimation:(FTCustomAnimation *)otherAnimation;

- (void)removeAllAnimations;

- (void)drawRect:(CGRect)rect forAnimation:(FTCustomAnimation *)animation withAnimationProgress:(float)progress;

- (void)animationWillBegin:(FTCustomAnimation *)animation;
- (void)animationDidFinish:(FTCustomAnimation *)animation;

- (void)addAnimationObserver:(id <FTCustomAnimationObserver>)observer;
- (void)removeAnimationObserver:(id <FTCustomAnimationObserver>)observer;

@end

@interface FTCustomAnimation : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) float (^customProgressForTime)(float time); //used if non nil, instead of animationCurve
@property (nonatomic, assign) BOOL disableUserInteraction; //default: NO
@property (nonatomic, assign) FTCustomAnimationCurve animationCurve; //default: FTCustomAnimationCurveEaseInOut

@end

@protocol FTCustomAnimationObserver <NSObject>

- (void)animationView:(FTCustomAnimationView *)animationView didChangeProgress:(float)progress forAnimation:(FTCustomAnimation *)animation;
- (void)animationView:(FTCustomAnimationView *)animationView willStartAnimation:(FTCustomAnimation *)animation;
- (void)animationView:(FTCustomAnimationView *)animationView didEndAnimation:(FTCustomAnimation *)animation;

@end
