//
//  FTSystem.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


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

+ (UIDeviceBatteryState)batteryState;

+ (CGFloat)batteryLevel;

+ (BOOL)iPhone;
+ (BOOL)iPad;
+ (BOOL)iPod;

+ (BOOL)isPhoneSize;
+ (BOOL)isTabletSize;

+ (BOOL)isRetina;

+ (UIInterfaceOrientation)interfaceOrientation;

+ (CGSize)screenSize;


@end
