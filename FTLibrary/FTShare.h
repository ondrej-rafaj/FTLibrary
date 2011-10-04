//
//  FTShare.h
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "FTShareDataObjects.h"
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


enum {
    FTShareOptionsMail              = 1 << 0,
    FTShareOptionsFacebook          = 1 << 1,
    FTShareOptionsTwitter           = 1 << 2
};
typedef NSUInteger FTShareOptions;

@protocol FTShareTwitterDelegate;
@protocol FTShareFacebookDelegate;
@protocol FTShareMailDelegate;

@interface FTShare : NSObject <MFMailComposeViewControllerDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FBRequestDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
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
- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret appID:(NSString *)appID andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)shareViaFacebook:(FTShareFacebookData *)data;

- (void)shareViaMail:(FTShareMailData *)data;

@end

@protocol FTShareTwitterDelegate <NSObject>
- (FTShareTwitterData *)twitterData;
- (void)twitterLoginDialogController:(UIViewController *)controller;
- (void)twitterDidLoginSuccesfully:(BOOL)success error:(NSError *)error;
- (void)twitterDidPostSuccesfully:(BOOL)success error:(NSError *)error;
@end

@protocol FTShareFacebookDelegate <NSObject>
- (FTShareFacebookData *)facebookShareData;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLoginSuccesfully:(BOOL)success error:(NSError *)error;
- (void)facebookDidPostSuccesfully:(BOOL)success error:(NSError *)error;
@end

@protocol FTShareMailDelegate <NSObject>
- (FTShareMailData *)mailShareData;
- (void)mailSentSuccesfully:(BOOL)success;
@end
