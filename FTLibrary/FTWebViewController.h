//
//  FTWebViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"


typedef enum {
	
	FTWebViewControllerDataMethodPost,
	FTWebViewControllerDataMethodGet
	
} FTWebViewControllerDataMethod;


@interface FTWebViewController : FTViewController <UIWebViewDelegate> {
	
	UIWebView *webView;
	
	BOOL enablePreloading;
	
	FTWebViewControllerDataMethod dataMethod;
	BOOL submitDataEverytime;
	
}

@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic) BOOL enablePreloading;

@property (nonatomic) FTWebViewControllerDataMethod dataMethod;
@property (nonatomic) BOOL submitDataEverytime;


- (void)loadUrlFromString:(NSString *)url withData:(NSArray *)data usingDataMethod:(FTWebViewControllerDataMethod)method;

- (void)loadUrlFromString:(NSString *)url;


@end
