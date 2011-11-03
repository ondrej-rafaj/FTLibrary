//
//  FTFacebookViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookViewController.h"
#import "UIView+Layout.h"
#import "UIColor+Tools.h"


@implementation FTFacebookViewController

@synthesize delegate;
@synthesize facebookAppId;
@synthesize useGridView;


#pragma mark Facebook stuff

- (Facebook *)facebook {
	FTAppDelegate *ad = [FTAppDelegate delegate];
	[ad.share setUpFacebookWithAppID:facebookAppId andDelegate:self];	
	return ad.share.facebook;
}

- (void)authorize {
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
								nil]];
}

#pragma mark Connection & Downloading stuff

- (void)downloadDataFromUrl:(NSString *)url {
	Facebook *fb = [self facebook];
	if (![fb isSessionValid]) {
		NSLog(@"Invalid session!!!!");
		[self authorize];
	}
	else {
		if (dataRequest) {
			[dataRequest cancel];
			[dataRequest setDelegate:nil];
		}
		[dataRequest release];
		dataRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
		//[dataRequest setCachePolicy:ASICacheForSessionDurationCacheStoragePolicy];
		[dataRequest setDelegate:self];
		[dataRequest startAsynchronous];
	}
}

- (void)noInternetConnection {
	
}

- (void)startDownloadingDataForCurrentPage {
	
}

#pragma mark ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	if (self != [self.navigationController.viewControllers objectAtIndex:0]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)_data {
	NSLog(@"Received data: %@", _data);
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	//[self.view setFrame:CGRectMake(0, 0, 320, 460)];
	
	UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
	[self.navigationItem setRightBarButtonItem:reload];
	[reload release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSLog(@"Final view size: %@", NSStringFromCGRect(self.view.frame));
	
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
	
	[self startDownloadingDataForCurrentPage];
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

//#pragma mark Facebook delegate methods
//
//- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//	NSLog(@"Facebook error: %@", [error localizedDescription]);
//}

#pragma mark FTShare delegate methods

- (void)facebookLoginDialogController:(UIViewController *)controller {
	NSLog(@"facebookLoginDialogController");
}

- (void)facebookDidLogin:(NSError *)error {
	NSLog(@"facebookDidLogin");
}

- (void)facebookDidPost:(NSError *)error {
	NSLog(@"facebookDidPost");
}

#pragma mark Facebook session delegate

//- (void)fbDidLogin {
//	NSLog(@"fbDidLogin");
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
//    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
//    [defaults synchronize];
//}
//
//- (void)fbDidNotLogin:(BOOL)cancelled {
//	NSLog(@"fbDidNotLogin:");
//}
//
//- (void)fbDidLogout {
//	NSLog(@"fbDidLogout");
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
//        [defaults removeObjectForKey:@"FBAccessTokenKey"];
//        [defaults removeObjectForKey:@"FBExpirationDateKey"];
//        [defaults synchronize];
//    }
//}

#pragma mark Memory management

- (void)dealloc {
	[_facebook release];
	[facebookAppId release];
	[dataRequest cancel];
	[dataRequest setDelegate:nil];
	[dataRequest release];
	[searchBar release];
	[super dealloc];
}


@end
