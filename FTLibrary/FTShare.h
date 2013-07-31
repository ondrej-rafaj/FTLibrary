//
//  FTShare.h
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

/**
 * This class provide a simple way to integarate share functionalities on your application.
 * There are 2 main ways of usign this component. The first is to call the shareWith... method while the second is to show the UIActionSheet and then utilize the delegate methods.
 * The FTShare main instance have to be part of the application APPDelegate as it uses the handleURL method for the facebook callback.
 * Remember to set URL Types on the info plist in order for the facebook callback to work. 
 */

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


#import "FTShareTwitter.h"
#import "FTShareEmail.h"

//  This definition can be used to determine whether the FTLibrary has Facebook support intergrated or is no-Facebook version compatible with up-to-date Facebook iOS SDK framework
//  Use compiler macro "#ifdef FTLIBRARY_NOFACEBOOK" to conditional compiling for no-facebook version
#define FTLIBRARY_NOFACEBOOK = 1

enum {
    FTShareOptionsMail              = 1 << 0,
    FTShareOptionsTwitter           = 1 << 2
};
typedef NSUInteger FTShareOptions;




@interface FTShare : NSObject <UIActionSheetDelegate> {
    
    FTShareTwitter *_twitterEngine;
    FTShareEmail *_emailEngine;
    
    id _referencedController;
}

@property (nonatomic, assign) id referencedController;


- (id)initWithReferencedController:(id)controller;
- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;

- (void)setUpEmailWithDelegate:(id<FTShareEmailDelegate>)delegate;
- (void)shareViaEmail:(FTShareEmailData *)data;

@end
