//
//  FTTracking.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTTracking.h"
#import "FTProjectInitialization.h"
#import "FTError.h"


@implementation FTTracking

- (void)logEvent:(NSString *)event {
	BOOL ok = NO;
	if ([FTProjectInitialization isUsing:FTProjectInitializationFunctionTypeTrackingFlurry]) {
		[FlurryAPI logEvent:event];
		ok = YES;
	}
	if ([FTProjectInitialization isUsing:FTProjectInitializationFunctionTypeTrackingGoogle]) {
		
		ok = YES;
	}
	if (!ok) {
		[FTError handleErrorWithString:@"No tracking has been initialized!"];
	}
}

@end
