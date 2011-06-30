//
//  FTSystemKillSwitch.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class FTSystemKillSwitch;

@protocol FTSystemKillSwitchDelegate <NSObject>

@required

- (void)appKillSwitch:(FTSystemKillSwitch *)killSwitch shouldDisableApp:(BOOL)disable;

@optional

- (UIView *)viewForAppKillSwitch:(FTSystemKillSwitch *)killSwitch;

@end


@interface FTSystemKillSwitch : NSObject {
	
	NSString *url;
	
	id <FTSystemKillSwitchDelegate> delegate;
	
	UIWindow *appWindow;
	
}

@property (nonatomic, retain) NSString *url;

@property (nonatomic, assign) id <FTSystemKillSwitchDelegate> delegate;
@property (nonatomic, assign) UIWindow *appWindow;


+ (id)instanceWithAppIdUrl:(NSString *)url;

- (id)initWithAppIdUrl:(NSString *)url;

+ (NSInteger)currentAppVersion;

+ (NSInteger)remoteAllowedAppVersion;

+ (BOOL)isAppEnabled;


@end
