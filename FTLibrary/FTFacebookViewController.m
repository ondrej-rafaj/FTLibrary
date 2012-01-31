//
//  FTFacebookViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookViewController.h"
#import "ASIDownloadCache.h"
#import "FTAppDelegate.h"
#import "UIView+Layout.h"
#import "UIColor+Tools.h"
#import "UIAlertView+Tools.h"


@implementation FTFacebookViewController

@synthesize delegate;
@synthesize facebookAppId;
@synthesize useGridView;
@synthesize download; 


#pragma mark Creating elements

- (void)createLoadingIndicator {
	UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[ai startAnimating];
	CGRect r = ai.bounds;
	r.size.width += 10;
	UIView *v = [[UIView alloc] initWithFrame:r];
	[v addSubview:ai];
	[ai release];
	UIBarButtonItem *loading = [[UIBarButtonItem alloc] initWithCustomView:v];
	[v release];
	[self.navigationItem setRightBarButtonItem:loading animated:YES];
	[loading release];
}

- (void)createReloadButton {
	UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didPressReloadButton:)];
	[self.navigationItem setRightBarButtonItem:reload];
	[reload release];
}

#pragma mark Facebook stuff

- (Facebook *)facebook {
	FTAppDelegate *ad = [FTAppDelegate delegate];
	[ad.share setUpFacebookWithAppID:facebookAppId permissions:FTShareFacebookPermissionNull andDelegate:self];	
	return ad.share.facebook;
}

- (void)authorizeWithOfflineAccess:(BOOL)offlineAccess {
	NSString *offline = @"offline_access";
	if (offlineAccess) offline = nil;
	[[self facebook] authorize:[NSArray arrayWithObjects:
								@"publish_stream",
								@"read_stream",
								@"read_friendlists",
								@"read_insights",
								@"user_birthday",
								@"friends_birthday",
								@"user_about_me",
								@"friends_about_me",
								@"user_photos",
								@"friends_photos",
								@"user_videos",
								@"friends_videos",
								offline,
								nil]];
}

- (void)authorize {
	[self authorizeWithOfflineAccess:NO];
}

- (void)authorizeWithOfflineRequestAccess {
//	FTAppDelegate *ad = [FTAppDelegate delegate];
//	if (![ad.share canUseOfflineAccess]) {
//		NSString *tl = FTLangGet(@"Facebook permissions");
//		NSString *ms = FTLangGet(@"Would you like to grant extended Facebook permissions to this app so you don't have to re-login again?");
//		NSString *ok = FTLangGet(@"YES");
//		NSString *cn = FTLangGet(@"NO");
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tl message:ms delegate:self cancelButtonTitle:cn otherButtonTitles:ok, nil];
//		[alert show];
//		[alert release];
//	}
//	else 
	[self authorizeWithOfflineAccess:YES];
}

#pragma mark Alert view permissions delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self authorizeWithOfflineAccess:YES];
	}
	else {
		[self authorizeWithOfflineAccess:NO];
	}
}

#pragma mark Connection & Downloading stuff

- (void)downloadDataFromUrl:(NSString *)url {
	Facebook *fb = [self facebook];
	if (![fb isSessionValid]) {
		[self authorizeWithOfflineRequestAccess];
	}
	else {
		[download release];
		download = [[FTDownload alloc] initWithPath:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[download setDelegate:self];
		[download startDownload];
	}
}

- (void)noInternetConnection {
	
}

- (void)startDownloadingDataForCurrentPage {
	
}

#pragma mark Download delegate methods

- (void)downloadFinishedWithResult:(NSString *)result {
	
}

- (void)downloadDataPercentageChanged:(CGFloat)percentage forObject:(FTDownload *)object {
	if (object == download) {
        //[self.progressView setProgress:(percentage / 100)];
		NSLog(@"Download in %f percent", percentage);
    }
}

- (void)downloadStatusChanged:(FTDownloadStatus)downloadStatus forObject:(FTDownload *)object {
    if (object == download) {
		if (downloadStatus != FTDownloadStatusActive) {
			
        }
        if (downloadStatus == FTDownloadStatusSuccessful) {
            NSString *s = [object.downloadRequest responseString];
            [self downloadFinishedWithResult:s];
			[self createReloadButton];
        }
        else if (downloadStatus == FTDownloadStatusFailed) {
            [UIAlertView showMessage:FTLangGet(@"Error downloading file") withTitle:FTLangGet(@"Error")];
			[self createReloadButton];
        }
    }
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithHexString:@"F2F2F2"]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDelayedReloadData) name:kFTAppDelegateDidOpenAppWithUrl object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[table setBackgroundColor:[UIColor clearColor]];
	[grid setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	UIView *v;
	if (!useGridView) v = table;
	else v = grid;
	[v setAutoresizingMask:UIViewAutoresizingNone];
	CGRect r = self.view.bounds;
	if (searchBar) {
		r.origin.y += [searchBar height];
		r.size.height -= 44;
	}
	[v setFrame:r];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	if (useGridView) [grid reloadData];
	
	if ([data count] <= 0) {
		[self startDownloadingDataForCurrentPage];
		[self createLoadingIndicator];
	}
}

- (void)createTableView {
	if (!useGridView) [super createTableView];
	else {
		grid = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, [self.view height])];
		[grid setDelegate:self];
		[grid setDataSource:self];
		[self.view addSubview:grid];
	}
}

#pragma mark Loading data

- (void)reloadData {
	if (!useGridView) [table reloadData];
	else [grid reloadData];
}

- (void)startDelayedReloadData {
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
}

- (void)didPressReloadButton:(UIBarButtonItem *)sender {
	[self createLoadingIndicator];
	[self reloadData];
}

#pragma mark Grid view delegate & data source methods

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
	return [data count];
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView {
	return CGSizeMake(150, 150);
}

- (void)configureGridCell:(FTGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView {
	[cell.contentView setBackgroundColor:[UIColor randomColor]];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *ci = @"FBAQGridViewCell";
	FTGridViewCell *cell = (FTGridViewCell *)[gridView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		cell = [[[FTGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 150, 150) reuseIdentifier:ci] autorelease];
	}
	[cell.imageView setImage:nil];
	[self configureGridCell:cell atIndex:index forGridView:grid];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	[gridView deselectItemAtIndex:index animated:NO];
}

#pragma mark Memory management

- (void)dealloc {
	[_facebook release];
	[facebookAppId release];
	[download release];
	[searchBar release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


@end
