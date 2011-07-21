//
//  FTWebViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"


@interface FTWebViewController : FTViewController <UIWebViewDelegate> {
	
	UIWebView *webView;
	
	BOOL enablePreloading;
	
}

@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic) BOOL enablePreloading;


- (void)loadUrlFromString:(NSString *)url;


@end
