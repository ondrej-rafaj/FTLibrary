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


@implementation FTFacebookPhotosViewController

@synthesize albumId;


#pragma mark Data handling

- (void)reloadData {
	Facebook *fb = [super facebook];
	if (![fb isSessionValid]) {
		NSLog(@"Invalid session!!!!");
		[super authorize];
	}
	else {
		NSLog(@"Session is valid!!! :)");
		NSString *url = [fb urlWithGraphPath:[NSString stringWithFormat:@"%@/photos", albumId] andParams:[NSMutableDictionary dictionary]];
		
		NSMutableArray *arr;
		NSString *fileName = [FTText getSafeText:url];
		NSString *cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:fileName];
		if (![FTFilesystemIO isFile:cacheFile]) {
			arr = [NSMutableArray arrayWithArray:[[FTDataJson jsonDataFromUrl:url] objectForKey:@"data"]];
			NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"updated_time" ascending:NO];
			[arr sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
			if ([arr count] > 0) [arr writeToFile:cacheFile atomically:YES];
			[super setData:[arr copy]];
		}
		else {
			arr = [NSMutableArray arrayWithContentsOfFile:cacheFile];
			[super setData:arr];
		}
		[table reloadData];
	}
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
	
	[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading pictures") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(reloadData) onTarget:self withObject:nil animated:YES];
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

#pragma mark Data delegate methods

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Facebook response: %@", response);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"Facebook result: %@", result);
}

- (void)facebookDidPost:(NSError *)error {
	NSLog(@"facebookDidPost:");
}

- (void)facebookDidLogin:(NSError *)error {
	NSLog(@"facebookDidLogin:");
}


@end
