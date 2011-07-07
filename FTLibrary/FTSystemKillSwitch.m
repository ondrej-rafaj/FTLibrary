//
//  FTSystemKillSwitch.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTSystemKillSwitch.h"
#import "FTDataJson.h"
#import "FTAppDelegate.h"


@implementation FTSystemKillSwitch

@synthesize url;
@synthesize delegate;
@synthesize appWindow;
@synthesize blockerShadow;


#pragma mark Positioning



#pragma mark Initialization

+ (id)instanceWithAppIdUrl:(NSString *)url {
	return [[[FTSystemKillSwitch alloc] initWithAppIdUrl:url] autorelease];
}

- (id)initWithAppIdUrl:(NSString *)url {
	self = [super init];
	if (self) {
		appWindow = [FTAppDelegate window];
		blockerShadow = 0.6;
	}
	return self;
}

#pragma mark Settings

+ (NSInteger)currentAppVersion {
	return 1;
}

+ (NSInteger)remoteAllowedAppVersion {
	return 1;
}

+ (BOOL)isAppEnabled {
	return YES;
}


#pragma mark Memory management

- (void)dealloc {
	[url release];
	[super dealloc];
}

@end
