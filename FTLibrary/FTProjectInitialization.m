//
//  FTProjectInitialization.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTProjectInitialization.h"
#import "FlurryAPI.h"
#import "FTLang.h"


#define kFTProjectInitializationFunctionalityKey				@"FTProjectInitializationFunctionalityKey"
#define kFTProjectInitializationDebuggingKey					@"FTProjectInitializationDebuggingKey"


@implementation FTProjectInitialization

@synthesize killSwitch;


#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (void)initialize {
	[FTLang loadLocalTranslations];
}

+ (void)resume {
	[FTLang loadLocalTranslations];
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

- (void)enableKillSwitchWith:(id<FTSystemKillSwitchDelegate>)del window:(UIWindow *)window andUrl:(NSString *)url {
    static BOOL execute = YES;
    if (!execute) return;
    
	self.killSwitch = [[FTSystemKillSwitch alloc] initWithAppURL:url];
    [self.killSwitch setDelegate:del];
    [self.killSwitch setAppWindow:window];
    [self.killSwitch killSwitchApp];
    execute = NO;
}

#pragma mark KillSwitch delegate & data source methods

- (void)appKillSwitch:(FTSystemKillSwitch *)killSwitch shouldDisableApp:(BOOL)disable {
	NSLog(@"App disabled looser :)");
}

- (UIView *)viewForAppKillSwitch:(FTSystemKillSwitch *)killSwitch {
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 60)];
	[lbl setText:[FTLang get:@"Application is unavailable at the moment. Sorry for any inconvenience caused"]];
	return lbl;
}

#pragma mark Debugging

+ (void)enableDebugging:(BOOL)debugging {
	[[NSUserDefaults standardUserDefaults] setBool:debugging forKey:kFTProjectInitializationDebuggingKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)debugging {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kFTProjectInitializationDebuggingKey];
}

#pragma mark Memory management

- (void)dealloc {
	[killSwitch release];
	[super dealloc];
}


@end
