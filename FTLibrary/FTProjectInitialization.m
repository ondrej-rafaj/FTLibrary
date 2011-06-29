//
//  FTProjectInitialization.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTProjectInitialization.h"
#import "FlurryAPI.h"


#define kFTProjectInitializationFunctionalityKey				@"FTProjectInitializationFunctionalityKey"


@implementation FTProjectInitialization

#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (void)initialize {
	
}

+ (void)resume {
	
}

#pragma mark Settings

+ (NSString *)functionalityKey:(FTProjectInitializationFunctionType)functionality {
	return [NSString stringWithFormat:@"%@%d", kFTProjectInitializationFunctionalityKey, functionality];
}

+ (void)setUsedFunctionality:(FTProjectInitializationFunctionType)functionality {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self functionalityKey:functionality]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUsing:(FTProjectInitializationFunctionType)functionality {
	return [[NSUserDefaults standardUserDefaults] boolForKey:[self functionalityKey:functionality]];
}

+ (void)enableFlurryWithApiKey:(NSString *)apiKey {
	[FlurryAPI startSession:apiKey];
	[self setUsedFunctionality:FTProjectInitializationFunctionTypeTrackingFlurry];
}


@end
