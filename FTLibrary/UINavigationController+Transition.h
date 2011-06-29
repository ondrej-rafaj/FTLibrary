//
//  UINavigationController+Transition.h
//  DarrenShan
//
//  Created by Simon Lee on 09/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UINavigationController (Transition)

- (void)pushViewController:(UIViewController *)controller transition:(UIViewAnimationTransition)transition;

- (void)pushViewControllerWithFade:(UIViewController *)controller;

- (void)popViewControllerWithFadeInTime:(NSTimeInterval)time;

- (void)popViewControllerWithFade;


@end
