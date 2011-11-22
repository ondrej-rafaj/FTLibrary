//
//  FTFacebookGalleriesViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookGalleriesViewController.h"
#import "FTFilesystem.h"
#import "FTDataJson.h"
#import "FTText.h"


@implementation FTFacebookGalleriesViewController

@synthesize userId;


#pragma mark Data handling

- (void)startDownloadingDataForCurrentPage {
	NSString *url = [[super facebook] urlWithGraphPath:[NSString stringWithFormat:@"%@/albums", userId] andParams:[NSMutableDictionary dictionary]];
	[super downloadDataFromUrl:url];
}

- (void)downloadFinishedWithResult:(NSString *)result {
	NSDictionary *d = [result JSONValue];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:[d objectForKey:@"data"]];
	
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"updated_time" ascending:NO];
	[arr sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
	NSMutableArray *clean = [NSMutableArray arrayWithArray:arr];
	for (NSDictionary *d in arr) {
		//NSLog(@"Dic: %@", d);
		if ([[d objectForKey:@"count"] intValue] <= 0) [clean removeObject:d];
	}
	//if ([arr count] > 0) [clean writeToFile:cacheFile atomically:YES];
	[super setData:[clean copy]];
	[table reloadData];
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
	[userId release];
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
	//[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading albums") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(reloadData) onTarget:self withObject:nil animated:YES];
}

#pragma mark Tableview delegate & data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ci = @"FTFacebookFriendCell";
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


@end
