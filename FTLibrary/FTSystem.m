//
//  FTSystem.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTSystem.h"


@implementation FTSystem

static FTSystemDeviceType cachedDeviceType;
static float systemVersion = -1;


+ (FTSystemDeviceType)deviceType {
	if (cachedDeviceType) return cachedDeviceType;
	NSString *dt = [UIDevice currentDevice].model;
	NSLog(@"Device type: %@", dt);
	if([dt isEqualToString:@"iPhone"] || [dt isEqualToString:@"iPhone Simulator"]) cachedDeviceType = FTSystemDeviceTypeiPhone;
	else if ([dt isEqualToString:@"iPad"] || [dt isEqualToString:@"iPad Simulator"]) cachedDeviceType = FTSystemDeviceTypeiPad;
	else if ([dt isEqualToString:@"iPod touch"]) cachedDeviceType = FTSystemDeviceTypeiPod;
	else cachedDeviceType = FTSystemDeviceTypeUnknown;
	return cachedDeviceType;
}

+ (NSString *)deviceName {
	return [UIDevice currentDevice].name;
}

+ (UIDeviceBatteryState)batteryState {
	return [UIDevice currentDevice].batteryState;
}

+ (CGFloat)batteryLevel {
	return [UIDevice currentDevice].batteryLevel;
}

+ (BOOL)iPhone {
	return ([self deviceType] == FTSystemDeviceTypeiPhone);
}

+ (BOOL)iPad {
	return ([self deviceType] == FTSystemDeviceTypeiPad);
}

+ (BOOL)iPod {
	return ([self deviceType] == FTSystemDeviceTypeiPod);
}

+ (BOOL)isPhoneSize {
	return ([self deviceType] == FTSystemDeviceTypeiPhone || [self deviceType] == FTSystemDeviceTypeiPod);
}

+ (BOOL)isTabletSize {
	return ([self deviceType] == FTSystemDeviceTypeiPad);
}

+ (BOOL)isRetina {
	return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00);
}

+ (UIInterfaceOrientation)interfaceOrientation {
	return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (CGSize)screenSize {
	return [[UIScreen mainScreen] bounds].size;
//	NSLog(@"Screen size: %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
//	CGSize s;
//	if ([self isPhoneSize]) {
//		
//		if (UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
//			s = CGSizeMake(480, 320);
//		}
//		else {
//			s = CGSizeMake(320, 480);
//		}
//	}
//	else {
//		if (UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
//			s = CGSizeMake(1024, 768);
//		}
//		else {
//			s = CGSizeMake(768, 1024);
//		}
//	}
//	return s;
}

+ (float)systemNumber
{
	if (systemVersion == -1)
	{
		NSString *version = [[UIDevice currentDevice] systemVersion];
		systemVersion = [version floatValue];
	}
	
	return systemVersion;
}

+ (BOOL) isInternetAvailable
{
#warning Change way to check internet connection
    NSError *error = nil;
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSUTF8StringEncoding error:&error];
    return (error == nil && ![result isEqualToString:@""]);
}

@end
