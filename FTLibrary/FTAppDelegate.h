//
//  FTAppDelegate.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTAppDelegate : NSObject


+ (id)delegate;

+ (UIWindow *)windowFromSelector:(SEL)selector;

+ (UIWindow *)window;


@end
