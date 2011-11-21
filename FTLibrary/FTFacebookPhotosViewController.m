//
//  FTFacebookPhotosViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookPhotosViewController.h"
#import "FTFilesystem.h"
#import "FTDataJson.h"
#import "FTText.h"
#import "UIView+Layout.h"


@implementation FTFacebookPhotosViewController

@synthesize albumId;


#pragma mark Data handling

- (void)startDownloadingDataForCurrentPage {
	NSString *url = [[super facebook] urlWithGraphPath:[NSString stringWithFormat:@"%@/photos", albumId] andParams:[NSMutableDictionary dictionary]];
	[super downloadDataFromUrl:url];
}

- (void)downloadFinishedWithResult:(NSString *)result {
	NSDictionary *d = [result JSONValue];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:[d objectForKey:@"data"]];
	
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"updated_time" ascending:NO];
	[arr sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
	[super setData:[arr copy]];
	[super reloadData];
}

- (void)reloadData {
	//	NSString *cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsList.cache"];
	//	[FTFilesystemIO deleteFile:cacheFile];
	//	cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsSortedArray.cache"];
	//	[FTFilesystemIO deleteFile:cacheFile];
	[self startDownloadingDataForCurrentPage];
}

#pragma mark Memory management

- (void)dealloc {
	[albumId release];
	[super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[super createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading pictures") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(reloadData) onTarget:self withObject:nil animated:YES];
}

#pragma mark Tableview delegate & data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ci = @"FTFacebookPhotosCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		cell = [[[FTTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ci] autorelease];
	}
	NSDictionary *d = [data objectAtIndex:indexPath.row];
	[cell.textLabel setText:[d objectForKey:@"name"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Grid view delegate & data source methods

- (void)configureGridCell:(FTGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView {
	NSDictionary *d = [data objectAtIndex:index];
	[cell.imageView loadImageFromUrl:[d objectForKey:@"picture"]];
	[cell.imageView makeMarginInSuperViewWithTopMargin:10 leftMargin:10 rightMargin:10 andBottomMargin:10];
	
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
}

//#pragma mark Data delegate methods
//
//- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
//	NSLog(@"Facebook response: %@", response);
//}
//
//- (void)request:(FBRequest *)request didLoad:(id)result {
//	NSLog(@"Facebook result: %@", result);
//}
//
//- (void)facebookDidPost:(NSError *)error {
//	NSLog(@"facebookDidPost:");
//}
//
//- (void)facebookDidLogin:(NSError *)error {
//	NSLog(@"facebookDidLogin:");
//}


@end
