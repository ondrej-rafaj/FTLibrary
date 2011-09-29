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


@protocol FTShareTwitterDelegate;
@protocol FTShareFacebookDelegate;
@protocol FTShareMailDelegate;

@interface FTShare : NSObject <MFMailComposeViewControllerDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FBSessionDelegate, FBDialogDelegate> {
    Facebook *_facebook;
    SA_OAuthTwitterEngine *_twitter;
    id<FTShareTwitterDelegate> _twitterDelegate;
    id<FTShareFacebookDelegate> _facebookDelegate;
    id<FTShareMailDelegate> _mailDelegate;
    id _referencedController;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitter;
@property (nonatomic, assign) id<FTShareTwitterDelegate> twitterDelegate;
@property (nonatomic, assign) id<FTShareFacebookDelegate> facebookDelegate;
@property (nonatomic, assign) id<FTShareMailDelegate> mailDelegate;

@property (nonatomic, assign) id referencedController;

- (id)initWithReferencedController:(id)controller;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret appID:(NSString *)appID andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(NSDictionary *)data;

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)shareViaFacebook:(NSDictionary *)data;

@end

@protocol FTShareTwitterDelegate <NSObject>
- (void)twitterLoginDialogController:(UIViewController *)controller;
- (void)twitterDidLoginSuccesfully:(BOOL)success error:(NSError *)error;
- (void)twitterDidPostSuccesfully:(BOOL)success error:(NSError *)error;
@end

@protocol FTShareFacebookDelegate <NSObject>
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLoginSuccesfully:(BOOL)success error:(NSError *)error;
- (void)facebookDidPostSuccesfully:(BOOL)success error:(NSError *)error;
@end

@protocol FTShareMailDelegate <NSObject>

@end
