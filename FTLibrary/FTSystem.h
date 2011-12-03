//
//  FTSystem.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	
	FTSystemDeviceTypeUnknown,
	FTSystemDeviceTypeiPad,
	FTSystemDeviceTypeiPhone,
	FTSystemDeviceTypeiPod
	
}
FTSystemDeviceType;


@interface FTSystem : NSObject {
    
}

+ (FTSystemDeviceType)deviceType;

+ (NSString *)deviceName;

+ (NSString *)uuid;

+ (UIDeviceBatteryState)batteryState;

+ (CGFloat)batteryLevel;

+ (BOOL)iPhone;
+ (BOOL)iPad;
+ (BOOL)iPod;

+ (BOOL)isPhoneSize;
+ (BOOL)isTabletSize;

+ (BOOL)isPhoneIdiom;
+ (BOOL)isTabletIdiom;

+ (BOOL)isRetina;

+ (UIInterfaceOrientation)interfaceOrientation;

+ (CGRect)screenRect;
+ (CGSize)screenSize;

+ (float)systemNumber;

+ (BOOL)isInternetPingAvailable;
+ (BOOL)isInternetAvailable;

+ (NSString *)deviceInfo;


@end
