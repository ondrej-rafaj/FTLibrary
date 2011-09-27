//
//  FTAlertView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 27/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTAlertView.h"
#import "FTLang.h"


void FTAlertWithError(NSError *error) {
	FTAlertWithTitleAndMessage(FTLangGet(@"Error"), [error localizedDescription]);
}

void FTAlertWithTitleAndMessage(NSString *title, NSString *message) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:FTLangGet(@"OK") otherButtonTitles: nil];
	[alert show];
	[alert release];
}


@implementation FTAlertView

@end
