//
//  FTProjectInitialization.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSystemKillSwitch.h"


typedef enum {
	
	FTProjectInitializationFunctionTypeTrackingFlurry,
	FTProjectInitializationFunctionTypeTrackingGoogle
	
} FTProjectInitializationFunctionType;


@interface FTProjectInitialization : NSObject <FTSystemKillSwitchDelegate> {
	
	FTSystemKillSwitch *killSwitch;
	
}

@property (nonatomic, retain) FTSystemKillSwitch *killSwitch;


+ (void)initialize;

+ (void)resume;

+ (void)enableFlurryWithApiKey:(NSString *)apiKey;

+ (void)setUsedFunctionality:(FTProjectInitializationFunctionType)functionality;

+ (BOOL)isUsing:(FTProjectInitializationFunctionType)functionality;

- (void)enableKillSwitchWith:(id<FTSystemKillSwitchDelegate>)del window:(UIWindow *)window andUrl:(NSString *)url;

+ (void)enableDebugging:(BOOL)debugging;

+ (BOOL)debugging;

+ (void)enableMemoryDebugging:(BOOL)debugging;

+ (BOOL)memoryDebugging;


@end
