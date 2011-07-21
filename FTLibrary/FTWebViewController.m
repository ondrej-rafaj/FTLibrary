//
//  FTWebViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTWebViewController.h"
#import "FTLang.h"


@implementation FTWebViewController

@synthesize webView;
@synthesize enablePreloading;


#pragma mark Initialization

- (void)initializingSequence {
	enablePreloading = YES;
}

#pragma mark Memory managemnt

- (void)dealloc {
	[webView setDelegate:nil];
	[webView stopLoading];
	[webView release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor redColor]];
	
	webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[webView setDelegate:self];
	[self.view addSubview:webView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Web loading

- (void)loadUrlFromString:(NSString *)url {
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark Web view delegate method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	if (enablePreloading) {
		//[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading") andAnimationStyle:FTProgressViewAnimationFade];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (enablePreloading) {
		//[super disableLoadingProgressView];
	}
}


@end
