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
#import "FTLang.h"


@class FTFacebookViewController;

@protocol FTFacebookViewControllerDelegate <NSObject>

@optional

- (void)facebookViewController:(FTFacebookViewController *)controller didSelectPicture:(NSString *)url withData:(NSDictionary *)data;

@end


@interface FTFacebookViewController : FTViewController <FTShareFacebookDelegate> {
	
	Facebook *_facebook;
	
	id <FTFacebookViewControllerDelegate> delegate;
	
}

@property (nonatomic, assign) id <FTFacebookViewControllerDelegate> delegate;


- (Facebook *)facebook;

- (void)authorize;

- (void)reloadData;

- (void)noInternetConnection;



@end
