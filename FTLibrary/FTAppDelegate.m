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

@synthesize share;

- (id)init {
    self = [super init];
    if (self) {
        share = [[FTShare alloc] initWithReferencedController:nil];
    }
    return self;
}

+ (FTAppDelegate *)delegate {
	return (FTAppDelegate *)[[UIApplication sharedApplication] delegate];
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

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (self.share.facebook) {
        return [self.share.facebook handleOpenURL:url];
    }
    return YES;
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (self.share.facebook) {
        return [self.share.facebook handleOpenURL:url];
    }
    return YES;
}


@end
