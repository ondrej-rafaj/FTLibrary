//
//  FTShare.m
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTShare.h"

@implementation FTShare

@synthesize facebook = _facebook;
@synthesize twitter = _twitter;
@synthesize twitterDelegate = _twitterDelegate;
@synthesize facebookDelegate = _facebookDelegate;
@synthesize mailDelegate = _mailDelegate;

@synthesize referencedController = _referencedController;

static FTShareTwitterData *_twitterParams;
static FTShareFacebookData *_facebookParams;

- (id)initWithReferencedController:(id)controller
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setReferencedController:controller];
        _twitterParams = nil;
        _facebookParams = nil;

    }
    
    return self;
}
- (void)dealloc {
    [_facebook release], _facebook = nil;
    [_twitter release], _twitter = nil;
    _twitterDelegate = nil;
    _facebookDelegate = nil;
    _mailDelegate = nil;
    _referencedController = nil;
    [super dealloc];
}

/**
 * Use this method, then implement the delegates
 */

- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:title 
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:nil];
    if (options & FTShareOptionsMail) [actionSheet addButtonWithTitle:@"Mail"];
    if (options & FTShareOptionsFacebook) [actionSheet addButtonWithTitle:@"Facebook"];
    if (options & FTShareOptionsTwitter) [actionSheet addButtonWithTitle:@"Twitter"];
    
    [actionSheet showInView:[(UIViewController *)self.referencedController view]];
}


/**
 *
 * Twitter Section
 *
 */

#pragma mark --
#pragma mark Twitter

// setting up twitter engine
- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret appID:(NSString *)appID andDelegate:(id<FTShareTwitterDelegate>)delegate {
    _twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    self.twitterDelegate = delegate;
    self.twitter.consumerKey = consumerKey;  
    self.twitter.consumerSecret = secret;
    //APP id not set yet
}

- (void)shareViaTwitter:(FTShareTwitterData *)data {
    _twitterParams = nil;
    _twitterParams = data;
    if(![self.twitter isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:self.twitter delegate:self];  
        
        if (controller && self.referencedController){  
            [(UIViewController *)self.referencedController presentModalViewController:controller animated:YES];
        }
    }
    else {
        if (![_twitterParams isRequestValid]) return;
        [self.twitter sendUpdate:_twitterParams.message];
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate 

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: data forKey: @"twitterAuthData"];  
    [defaults synchronize];  
}

- (void)clearCachedTwitterOAuthData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: nil forKey: @"twitterAuthData"];  
    [defaults synchronize];     
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"twitterAuthData"];  
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier); 
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPost:)]) {
        [self.twitterDelegate twitterDidPost:nil];
    }
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPost:)]) {
        [self.twitterDelegate twitterDidPost:error];
    }
}

#pragma mark Twitter login

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:nil];
    }
    [self shareViaTwitter:_twitterParams];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Couldn't share with twitter" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:error];
    }
}

/**
 *
 * Facebook Section
 *
 */

#pragma mark --
#pragma mark Facebook

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate {
    _facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    self.facebookDelegate = delegate;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appID forKey:@"FTShareFBAppID"];
    [defaults synchronize];
    
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
}

- (void)shareViaFacebook:(FTShareFacebookData *)data {
    _facebookParams = nil;
    _facebookParams = data;
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:[NSArray arrayWithObjects:@"publish_stream", @"read_stream", nil]];
    }
    else {
        if (![_facebookParams isRequestValid]) return;
        UIImage *img = _facebookParams.uploadImage;
        if (img && [img isKindOfClass:[UIImage class]]) {
            [self.facebook requestWithGraphPath:@"me/photos" andParams:[_facebookParams dictionaryFromParams] andHttpMethod:@"POST" andDelegate:self];
        }
        else {
            [self.facebook dialog:@"feed" andParams:[_facebookParams dictionaryFromParams] andDelegate:self]; 
        }
    }
}


#pragma mark Facebook dialog

- (void)dialogDidComplete:(FBDialog *)dialog {
	if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
}
- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"Couldn't post with facebook", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"description", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
}

#pragma mark Facebook login

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"%@ %@", self.facebook.accessToken, self.facebook.expirationDate.description);
    
	
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:nil];
    }
    
    if (_facebookParams) {
        [self shareViaFacebook:_facebookParams];
    }
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"Couldn't login with facebook", [NSNumber numberWithBool:cancelled], nil]
                                                     forKeys:[NSArray arrayWithObjects:@"description", @"cancelled", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:error];
    }
}

#pragma mark FAcebook REquest delegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
}

/**
 *
 * Mail Section
 *
 */

#pragma mark --
#pragma mark Mail
- (void)shareViaMail:(FTShareMailData *)data {
    if (![data isRequestValid]) return;

	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; 
	mc.mailComposeDelegate = self;  
	
	[mc setSubject:data.subject];  
	
	[mc setMessageBody:data.plainBody isHTML:NO];
    if (data.htmlBody && [data.htmlBody length] > 0) {
        [mc setMessageBody:data.htmlBody isHTML:YES];
    }
	
    if (data.attachments && [data.attachments count] > 0) {
        for (NSDictionary *dict in data.attachments) {
            NSData *data = [dict objectForKey:@"data"];
            NSString *type = [dict objectForKey:@"type"];
            NSString *name = [dict objectForKey:@"name"];
            [mc addAttachmentData:data mimeType:type fileName:name];
        }
    }
	
	[mc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    

	if(mc) [self.referencedController presentModalViewController:mc animated:YES];
	[mc release];  
}


#pragma mark Mail controller delegates
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
   
    if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailSent:)]) {
        [self.mailDelegate mailSent:result];
    }
    [controller dismissModalViewControllerAnimated:YES];
}
 

#pragma mark --
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *btnText = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"Mail"]) {
        //implement mail
        if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailShareData)]) {
            FTShareMailData *data = [self.mailDelegate mailShareData];
            if (!data) return;
            [self shareViaMail:data];
        }
    }
    else  if ([btnText isEqualToString:@"Facebook"]) {
        //implement FAcebook
        if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookShareData)]) {
            FTShareFacebookData *data = [self.facebookDelegate facebookShareData];
            if (!data) return;
            [self shareViaFacebook:data];
        }
    }
    else  if ([btnText isEqualToString:@"Twitter"]) {
        //implement Twitter
        if (self.twitterDelegate && [self.twitterDelegate respondsToSelector:@selector(twitterData)]) {
            FTShareTwitterData *data = [self.twitterDelegate twitterData];
            [self shareViaTwitter:data];
        }
    }
}


@end
