//
//  UITabBarController+ItemsState.m
//  FTLibrary
//
//  Created by Simon Lee on 20/09/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "UITabBarController+ItemsState.h"


@implementation UITabBarController (ItemsState)

- (void) setItemsEnabled:(BOOL)enabled {
	for(UITabBarItem *item in [self.tabBar items]) {
		[item setEnabled:enabled];
	}	
}

@end
