//
//  FTFacebookFriendsViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookFriendsViewController.h"
#import "FTLang.h"
#import "FTDataJson.h"
#import "FTFilesystem.h"


@implementation FTFacebookFriendsViewController


#pragma mark Data handling

- (void)reloadData {
	Facebook *fb = [super facebook];
	if (![fb isSessionValid]) {
		NSLog(@"Invalid session!!!!");
		[super authorize];
	}
	else {
		NSLog(@"Session is valid!!! :)");
		NSString *url = [fb urlWithGraphPath:@"me/friends" andParams:[NSMutableDictionary dictionary]];
		
		NSMutableArray *arr;
		NSString *cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsList.cache"];
		if (![FTFilesystemIO isFile:cacheFile]) {
			arr = [NSMutableArray arrayWithArray:[[FTDataJson jsonDataFromUrl:url] objectForKey:@"data"]];
			if ([arr count] > 0) [arr writeToFile:cacheFile atomically:YES];
		}
		else {
			arr = [NSMutableArray arrayWithContentsOfFile:cacheFile];
		}
		
		// Creating index sections
		sections = [[NSMutableDictionary alloc] init];
		BOOL found;
		for (NSDictionary *friend in arr) {
			NSString *c = [[friend objectForKey:@"name"] substringToIndex:1];
			found = NO;
			for (NSString *str in [sections allKeys]) {
				if ([str isEqualToString:c]) {
					found = YES;
				}
			}
			if (!found) {
				[sections setValue:[NSMutableArray array] forKey:c];
			}
		}
		
		[sections setValue:[NSMutableArray array] forKey:@"-"];
		NSMutableDictionary *me = [NSMutableDictionary dictionary];
		[me setValue:@"me" forKey:@"id"];
		[me setValue:@"Ondrej Rafaj (me)" forKey:@"name"];
		[[sections objectForKey:@"-"] addObject:me];
		
		// Adding friends to appropriate sections
		for (NSDictionary *friend in arr) {
			[[sections objectForKey:[[friend objectForKey:@"name"] substringToIndex:1]] addObject:friend];
		}
		
		// Sorting sections
		for (NSString *key in [sections allKeys]) {
			[[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
		}
		
		[table reloadData];
		NSLog(@"TableSize: %@", NSStringFromCGRect(self.table.frame));
	}
}

- (NSDictionary *)dictionaryForFriendAtIndexPath:(NSIndexPath *)indexPath {
	return (NSDictionary *)[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

#pragma mark Memory management

- (void)dealloc {
	[sections release];
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
	
	[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading friends") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(reloadData) onTarget:self withObject:nil animated:YES];
}

#pragma mark Tableview delegate & data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ci = @"FTFacebookFriendCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		cell = [[[FTTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ci] autorelease];
	}
	NSDictionary *d = [self dictionaryForFriendAtIndexPath:indexPath];
	[cell.textLabel setText:[d objectForKey:@"name"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
