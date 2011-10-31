//
//  FTFacebookViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"
#import "Facebook.h"
#import "FTAppDelegate.h"
#import "FTShare.h"


@interface FTFacebookViewController : FTViewController <UITableViewDelegate, UITableViewDataSource, FTShareFacebookDelegate> {
	
	Facebook *_facebook;
	
}

- (Facebook *)facebook;

- (void)reloadData;



@end
