//
//  FTShare.h
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


@protocol FTShareDelegate;
@interface FTShare : NSObject <MFMailComposeViewControllerDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FBSessionDelegate> {
    Facebook *_facebook;
    SA_OAuthTwitterEngine *_twitter;
    id<FTShareDelegate> _delegate;
    id _referencedController;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitter;
@property (nonatomic, assign) id<FTShareDelegate> delegate;
@property (nonatomic, assign) id referencedController;

- (id)initWithReferencedController:(id)controller;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andAppID:(NSString *)appID;
- (void)shareViaTwitter:(NSDictionary *)data;

- (void)setUpFacebookWithAccessToken:(NSString *)token andAppID:(NSString *)appID;


@end

@protocol FTShareDelegate <NSObject>
- (void)twitterLoginDialogController:(UIViewController *)controller;
@end
