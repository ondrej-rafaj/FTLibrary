//
//  UINavigationController+Transition.m
//  DarrenShan
//
//  Created by Simon Lee on 09/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UINavigationController+Transition.h"


@implementation UINavigationController (Transition)

- (void)pushViewController:(UIViewController *)controller transition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:controller animated:NO];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationBeginsFromCurrentState:YES];        
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)pushViewControllerWithFade:(UIViewController *)controller {
	controller.view.alpha = 0.0;
	
	[UIView beginAnimations:nil context:nil];
	[self pushViewController:controller animated:NO];
	[UIView setAnimationDuration:0.75];
	controller.view.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)popViewControllerWithFade {
	UIViewController *vc = self.visibleViewController;
	[vc retain];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	vc.view.alpha = 0.0;
	[UIView commitAnimations];
	
	[self popViewControllerAnimated:NO];
}

@end
