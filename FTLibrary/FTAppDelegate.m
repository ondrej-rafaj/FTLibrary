//
//  FTAppDelegate.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTLanguageManager.h"
#import "Facebook.h"


@implementation FTAppDelegate

+ (id)delegate {
	return [[UIApplication sharedApplication] delegate];
}

+ (UIWindow *)windowFromSelector:(SEL)selector {
	if ([[UIApplication sharedApplication] respondsToSelector:selector]) {
		return [[UIApplication sharedApplication] performSelector:selector];
	}
	else return nil;
}

+ (UIWindow *)window {
	return [self windowFromSelector:@selector(window)];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    Facebook *facebook = [[Facebook alloc] init];
    return  [facebook handleOpenURL:url];
}

@end
