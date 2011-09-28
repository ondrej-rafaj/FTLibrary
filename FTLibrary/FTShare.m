//
//  FTShare.m
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTShare.h"

@implementation FTShare

@synthesize facebook = _facebook;
@synthesize twitter = _twitter;
@synthesize delegate = _delegate;
@synthesize referencedController = _referencedController;

static NSDictionary *_twitterParams;
static NSDictionary *_facebookParams;

- (id)initWithReferencedController:(id)controller
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setDelegate:controller];
        [self setReferencedController:controller];

    }
    
    return self;
}
- (void)dealloc {
    [_facebook release], _facebook = nil;
    [_twitter release], _twitter = nil;
    _delegate = nil;
    _referencedController = nil;
    [super dealloc];
}


// setting up twitter engine
- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andAppID:(NSString *)appID {
    _twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    self.twitter.consumerKey = consumerKey;  
    self.twitter.consumerSecret = secret;
    //APP id not set yet
}

- (void)shareViaTwitter:(NSDictionary *)data {
    if(![self.twitter isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:self.twitter delegate:self];  
        
        if (controller && self.referencedController){  
            [(UIViewController *)self.referencedController presentModalViewController:controller animated:YES];
        }
        else {
            [self.twitter sendUpdate:@"text to update"];
        }
    }
}

- (void)setUpFacebookWithAccessToken:(NSString *)token andAppID:(NSString *)appID {
    _facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];

	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
}

@end
