//
//  FTAppDelegate.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FTShare.h"

@interface FTAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> 

@property (nonatomic, retain) FTShare *share;

+ (FTAppDelegate *)delegate;

+ (UIWindow *)windowFromSelector:(SEL)selector;

+ (UIWindow *)window;


@end
