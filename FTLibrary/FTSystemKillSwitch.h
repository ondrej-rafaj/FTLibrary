//
//  FTSystemKillSwitch.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FTSystemKillSwitchMessage : NSObject {

    NSString *title;
    NSString *message;
    NSURL *web;
    NSURL *appStore;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSURL *web;
@property (nonatomic, retain) NSURL *appStore;

@end


@interface FTSystemKillSwitchVersions : NSObject {
    float minimum;
    float live;
    float staging;
    float current;
}

@property (nonatomic, assign) float minimum;
@property (nonatomic, assign) float live;
@property (nonatomic, assign) float staging;
@property (nonatomic, assign) float current;

@end


@protocol FTSystemKillSwitchDelegate;
@interface FTSystemKillSwitch : NSObject {
	
	NSString *url;	
	UIWindow *appWindow;
    CGFloat blockerShadow;
    NSString *hash;
    FTSystemKillSwitchVersions *versions;    
    FTSystemKillSwitchMessage *message;
    BOOL isDebugActive;
    BOOL isApplicationLocked;
    
    id <FTSystemKillSwitchDelegate> delegate;
	
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) IBOutlet UIWindow *appWindow;
@property (nonatomic, assign) CGFloat blockerShadow;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) FTSystemKillSwitchVersions *versions;
@property (nonatomic, retain) FTSystemKillSwitchMessage *message;
@property (nonatomic, assign) BOOL isDebugActive;
@property (nonatomic, assign) BOOL isApplicationLocked;
@property (nonatomic, retain) id <FTSystemKillSwitchDelegate> delegate;


- (id)initWithAppURL:(NSString *)aUrl;
- (void)killSwitchApp; 
+ (float)currentAppVersion;
+ (void)setCurrentAppVersion:(float)currentVersion;
+ (BOOL)isApplicationLocked;
+ (NSInteger)alertViewTag;



@end

@protocol FTSystemKillSwitchDelegate <NSObject>
@required
- (void)appKillSwitch:(FTSystemKillSwitch *)killSwitch shouldDisableApp:(BOOL)disable;


@optional

- (UIView *)viewForAppKillSwitchWithMessage:(FTSystemKillSwitchMessage *)message;
- (float)appVersion;
- (CGFloat)killSwitchViewShadow;
- (void)killSwitchDidFinish;

@end
