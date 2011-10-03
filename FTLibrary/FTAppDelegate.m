//
//  FTAppDelegate.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTLanguageManager.h"


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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appID = [defaults objectForKey:@"FTShareFBAppID"];
    
    Facebook *facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    return  [facebook handleOpenURL:url];
}

#pragma mark delegate

- (void)fbDidLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FTShareFBDidLoginNotification" object:nil];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FTShareFBDidNotLoginNotification" object:nil];
}

- (void)fbDidLogout {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FTShareFBDidLogoutNotification" object:nil];
}

@end
