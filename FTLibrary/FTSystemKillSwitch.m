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
#import "UIView+Layout.h"

#define kFTSystemKillSwitchHash                 @"FTSystemKillSwitchHash"
#define kFTSystemKillSwitchVersions             @"FTSystemKillSwitchVersions"

#define kFTSystemKillSwitchAbortNotification    @"FTSystemKillSwitchAbortNotification"


@implementation FTSystemKillSwitchMessage

@synthesize title;
@synthesize message;
@synthesize web;
@synthesize appStore;


- (void)dealloc {
    
    [title release];
    [message release];
    [web release];
    [appStore release];
    [super dealloc];
}

@end

@interface FTSystemKillSwitch(Private)
-(void)foreGroundResult;
@end

@implementation FTSystemKillSwitch

@synthesize url;
@synthesize appWindow;
@synthesize blockerShadow;
@synthesize hash;
@synthesize versions;
@synthesize message;
@synthesize isDebugActive;
@synthesize delegate;



#pragma mark Data;

- (NSString *)hash {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kFTSystemKillSwitchHash];
}

- (void)setHash:(NSString *)aHash {
     [[NSUserDefaults standardUserDefaults] setObject:aHash forKey:kFTSystemKillSwitchHash];
}

- (FTSystemKillSwitchVersions)versions {
    
    NSDictionary *resutls = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kFTSystemKillSwitchVersions];
    FTSystemKillSwitchVersions ver;
    ver.live = [[resutls objectForKey:@"live"] floatValue];
    ver.minimum = [[resutls objectForKey:@"minimum"] floatValue];
    ver.staging = [[resutls objectForKey:@"staging"] floatValue];
    
    return ver;
}

- (void)setVersions:(FTSystemKillSwitchVersions)someVersions {
    NSDictionary *ver = [NSDictionary 
                         dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:someVersions.live], [NSNumber numberWithFloat:someVersions.minimum], [NSNumber numberWithFloat:someVersions.staging], nil] 
                         forKeys:[NSArray arrayWithObjects:@"live", @"minimum", @"staging", nil]];
    [[NSUserDefaults standardUserDefaults] setObject:ver forKey:kFTSystemKillSwitchVersions];
}

- (void)getData {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *type = (isDebugActive)? @"staging" : @"live";
    NSString *request = [NSString stringWithFormat:@"%@/module-killswitch/%@.json", url, type]; //http://new.fuerteint.com/_files/calpol_testing/killswitch/live.json
    NSDictionary *dictionaryData = [FTDataJson jsonDataFromUrl:request];
    if (isDebugActive) {
        versions.staging = [[dictionaryData objectForKey:@"version"] floatValue];
        versions.live = 0.0;
    }
    else {
        versions.live = [[dictionaryData objectForKey:@"version"] floatValue];
        versions.staging = 0.0;
    }
    
    NSDictionary *data = [dictionaryData objectForKey:@"data"];
    versions.minimum = [[data objectForKey:@"minversion"] floatValue];
    
    message = [[FTSystemKillSwitchMessage alloc] init];
    message.title = [data objectForKey:@"title"];
    message.message = [data objectForKey:@"message"];
    message.web = [NSURL URLWithString:[data objectForKey:@"web"]];
    message.appStore = [NSURL URLWithString:[data objectForKey:@"appstore"]];
    
    [self performSelectorOnMainThread:@selector(foreGroundResult) withObject:nil waitUntilDone:NO];
    
    [pool drain];
    
}

- (void)foreGroundResult {
    
    //check version
    if (versions.current < versions.minimum) {

        [[NSNotificationCenter defaultCenter] postNotificationName:kFTSystemKillSwitchAbortNotification object:nil];
        //show view on window
        if(appWindow) {
            UIView *shadow = [[UIView alloc] initWithFrame:appWindow.bounds];
            [shadow setBackgroundColor:[UIColor blackColor]];
            [shadow setAlpha:blockerShadow];
            [appWindow addSubview:shadow];
            [shadow release];
            
            UIView *alertView;
            if ([[self delegate] respondsToSelector:@selector(viewForAppKillSwitchWithMessage:)]) {
                alertView = [[self delegate] viewForAppKillSwitchWithMessage:message];
                [alertView retain];
            }
            else {
                float w = appWindow.bounds.size.width - 40;
                float h =  appWindow.bounds.size.height - 40;
                alertView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, w, h)];
            }

            [appWindow addSubview:alertView];
            [alertView centerInSuperView];
            [alertView release];
                
        }
    }
}


#pragma mark Initialization

- (id)initWithAppURL:(NSString *)aUrl {
	self = [super init];
	if (self) {
        url = [aUrl retain];
        isDebugActive = NO;
		appWindow = [FTAppDelegate window];
		blockerShadow = 0.6;
        
        
	}
	return self;
}

- (void)killSwitchApp {
        versions.current = [FTSystemKillSwitch currentAppVersion];
    
    [self performSelectorInBackground:@selector(getData) withObject:nil];
}

#pragma mark Settings

+ (float)currentAppVersion {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    float versionFloat = [version floatValue];
    return  versionFloat;
}

+ (void)setCurrentAppVersion:(float)current {
    FTSystemKillSwitch *ks = [[FTSystemKillSwitch alloc] init];
    FTSystemKillSwitchVersions ver = [ks versions];
    
    
	ver.current = current;
    [ks setVersions:ver];
    [ks release];
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
    [appWindow release];
    [hash release];
    delegate = nil;
	[super dealloc];
}

@end
