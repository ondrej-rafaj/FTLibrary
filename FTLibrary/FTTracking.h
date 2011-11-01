//
//  FTTracking.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlurryAnalytics.h"


@interface FTTracking : NSObject


+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)params;
+ (void)logEvent:(NSString *)event;

+ (void)logFacebookUserInfo:(NSDictionary *)info;


@end
