//
//  FTFacebookViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookViewController.h"

@implementation FTFacebookViewController

@synthesize delegate;


#pragma mark Facebook stuff

- (Facebook *)facebook {
	FTAppDelegate *ad = [FTAppDelegate delegate];
	[ad.share setUpFacebookWithAppID:@"251581381542024" andDelegate:self];	
	return ad.share.facebook;
}

- (void)authorize {
	[[self facebook] authorize:[NSArray arrayWithObjects:@"publish_stream", @"read_stream", @"read_friendlists", @"read_insights", @"user_birthday", @"user_about_me", @"friends_photos", nil]];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setFrame:CGRectMake(0, 0, 320, 460)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (table) [table setFrame:CGRectMake(0, 0, 320, 416)];
	[self.view setFrame:CGRectMake(0, 0, 320, 460)];
}

#pragma mark Loading data

- (void)reloadData {
	
}

#pragma mark Tableview delegate & data source methods

//#pragma mark Facebook delegate methods
//
//- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//	NSLog(@"Facebook error: %@", [error localizedDescription]);
//}

#pragma mark FTShare delegate methods

- (void)facebookLoginDialogController:(UIViewController *)controller {
	NSLog(@"facebookLoginDialogController");
}

- (void)facebookDidLogin:(NSError *)error {
	NSLog(@"facebookDidLogin");
}

- (void)facebookDidPost:(NSError *)error {
	NSLog(@"facebookDidPost");
}

#pragma mark Facebook session delegate

//- (void)fbDidLogin {
//	NSLog(@"fbDidLogin");
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
//    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
//    [defaults synchronize];
//}
//
//- (void)fbDidNotLogin:(BOOL)cancelled {
//	NSLog(@"fbDidNotLogin:");
//}
//
//- (void)fbDidLogout {
//	NSLog(@"fbDidLogout");
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
//        [defaults removeObjectForKey:@"FBAccessTokenKey"];
//        [defaults removeObjectForKey:@"FBExpirationDateKey"];
//        [defaults synchronize];
//    }
//}

#pragma mark Memory management

- (void)dealloc {
	[_facebook release];
	[super dealloc];
}


@end
