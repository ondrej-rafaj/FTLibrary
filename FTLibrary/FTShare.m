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
@synthesize twitterDelegate = _twitterDelegate;
@synthesize facebookDelegate = _facebookDelegate;
@synthesize mailDelegate = _mailDelegate;

@synthesize referencedController = _referencedController;

static NSDictionary *_twitterParams;
static NSMutableDictionary *_facebookParams;

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

- (void)shareViaTwitter:(NSDictionary *)data {
    _twitterParams = nil;
    _twitterParams = data;
    if(![self.twitter isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:self.twitter delegate:self];  
        
        if (controller && self.referencedController){  
            [(UIViewController *)self.referencedController presentModalViewController:controller animated:YES];
        }
    }
    else {
        [self.twitter sendUpdate:[_twitterParams objectForKey:@"message"]];
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
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPostSuccesfully:error:)]) {
        [self.twitterDelegate twitterDidPostSuccesfully:YES error:nil];
    }
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPostSuccesfully:error:)]) {
        [self.twitterDelegate twitterDidPostSuccesfully:NO error:error];
    }
}

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLoginSuccesfully:error:)]) {
        [self.twitterDelegate twitterDidLoginSuccesfully:YES error:nil];
    }
    [self shareViaTwitter:_twitterParams];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Couldn't share with facebook" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLoginSuccesfully:error:)]) {
        [self.twitterDelegate twitterDidLoginSuccesfully:NO error:error];
    }
}



#pragma mark --
#pragma mark Facebook

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate {
    _facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    self.facebookDelegate = delegate;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
}

- (void)shareViaFacebook:(NSDictionary *)data {
    _facebookParams = [data mutableCopy];
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:nil];
    }
    else {
        [self.facebook dialog:@"feed" andParams:_facebookParams andDelegate:self];
    }
}

- (void)dialogDidComplete:(FBDialog *)dialog {
	
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];	
    if (_facebookParams) {
        [self.facebook dialog:@"feed" andParams:_facebookParams andDelegate:self];
    }
    else {
        //delegate did login
    }
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    //delegate did login
}

@end
