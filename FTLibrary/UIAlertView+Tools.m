//
//  UIAlertView+Tools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 17/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UIAlertView+Tools.h"
#import "FTLang.h"


@implementation UIAlertView (UIAlertView_Tools)

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
	[alert show];
	[alert release];
}


@end
