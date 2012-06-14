//
//  FTSystem.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTSystem.h"
#import "Reachability.h"


@implementation FTSystem

static FTSystemDeviceType cachedDeviceType;
static float systemVersion = -1;


+ (FTSystemDeviceType)deviceType {
	if (cachedDeviceType) return cachedDeviceType;
	NSString *dt = [UIDevice currentDevice].model;
	//NSLog(@"Device type: %@", dt);
	if([dt isEqualToString:@"iPhone"] || [dt isEqualToString:@"iPhone Simulator"]) cachedDeviceType = FTSystemDeviceTypeiPhone;
	else if ([dt isEqualToString:@"iPad"] || [dt isEqualToString:@"iPad Simulator"]) cachedDeviceType = FTSystemDeviceTypeiPad;
	else if ([dt isEqualToString:@"iPod touch"]) cachedDeviceType = FTSystemDeviceTypeiPod;
	else cachedDeviceType = FTSystemDeviceTypeUnknown;
	return cachedDeviceType;
}

+ (NSString *)deviceName {
	return [UIDevice currentDevice].name;
}

+ (NSString *)uuid {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	assert(uuid != NULL);
		
	CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
	assert(uuidStr != NULL);
	
	NSString *result = [NSString stringWithFormat:@"%@", uuidStr];
	return result;
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

+ (BOOL)isPhoneIdiom {
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isTabletIdiom {
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

+ (BOOL)isRetina {
	return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00);
}

+ (UIInterfaceOrientation)interfaceOrientation {
	return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (CGRect)screenRect {
	return [[UIScreen mainScreen] bounds];
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

+ (CGSize)screenSize {
	return [self screenRect].size;
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

+ (BOOL)isInternetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    BOOL isConnected = ([reachability isReachable]);
    return isConnected;
}

+ (BOOL)isInternetPingAvailable {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.google.com"];
    BOOL isConnected = ([reachability isReachable]);
    return isConnected;
}

+ (NSString *)deviceInfo {
	NSString *info = [NSString stringWithFormat:@"%@ version: %@\n", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
	info = [info stringByAppendingFormat:@"Model: %@\n", [[UIDevice currentDevice] model]];
	info = [info stringByAppendingFormat:@"Orientation: %d\n", [[UIDevice currentDevice] orientation]];
	info = [info stringByAppendingFormat:@"Retina: %d\n", [self isRetina]];
	info = [info stringByAppendingFormat:@"Bundle version: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	info = [info stringByAppendingFormat:@"Short version: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
	return info;
}

+ (void)printAvailableFonts
{
	NSMutableString *string = [NSMutableString stringWithString:@"\n"];
	for (NSString *fontFamilyName in [UIFont familyNames]) {
		[string appendFormat:@"\n%@", fontFamilyName];
		for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
			[string appendFormat:@"\n\t%@", fontName];
		}
	}
	NSLog(@"AVailable Fonts:%@", string);
}

@end
