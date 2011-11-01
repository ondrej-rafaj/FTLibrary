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
#import "FTSystem.h"
#import "FTTracking.h"
#import "UIColor+Tools.h"


@implementation FTFacebookFriendsViewController


#pragma mark Data handling

- (void)reloadData {
	if ([FTSystem isInternetAvailable]) {
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
			
			[super setData:arr];
			
			cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsSortedArray.cache"];
			if (![FTFilesystemIO isFile:cacheFile]) {
				
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
				
				// Getting informations about myself
				url = [fb urlWithGraphPath:@"me" andParams:[NSMutableDictionary dictionary]];
				NSDictionary *info = [FTDataJson jsonDataFromUrl:url];
				
				// Flurry
				[FTTracking logFacebookUserInfo:info];
				
				// Setting informations about myself
				[sections setValue:[NSMutableArray array] forKey:@"{search}"];
				NSMutableDictionary *me = [NSMutableDictionary dictionary];
				[me setValue:[info objectForKey:@"id"] forKey:@"id"];
				[me setValue:[NSString stringWithFormat:@"%@ (%@)", [info objectForKey:@"name"], FTLangGet(@"me")] forKey:@"name"];
				[[sections objectForKey:@"{search}"] addObject:me];
				
				// Adding friends to appropriate sections
				for (NSDictionary *friend in arr) {
					[[sections objectForKey:[[friend objectForKey:@"name"] substringToIndex:1]] addObject:friend];
				}
				
				// Sorting sections
				for (NSString *key in [sections allKeys]) {
					[[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
				}
				[sections writeToFile:cacheFile atomically:YES];
			}
			else {
				sections = [NSMutableArray arrayWithContentsOfFile:cacheFile];
			}
			
			[table reloadData];
			NSLog(@"TableSize: %@", NSStringFromCGRect(self.table.frame));
		}
	}
	else {
		[self enableLoadingProgressViewInWindowWithTitle:FTLangGet(@"No internet connection") andAnimationStyle:FTProgressViewAnimationFade];
		[NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(disableLoadingProgressView) userInfo:nil repeats:NO];
		[self noInternetConnection];
	}
}

- (NSDictionary *)dictionaryForFriendAtIndexPath:(NSIndexPath *)indexPath {
	if (!isSearching) return (NSDictionary *)[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	else return [searchArray objectAtIndex:indexPath.row];
}

#pragma mark Memory management

- (void)dealloc {
	[sections release];
	[searchArray release];
	[super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[super createTableView];
	[table setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[super enableLoadingProgressViewWithTitle:FTLangGet(@"Loading friends") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(reloadData) onTarget:self withObject:nil animated:YES];
}

#pragma mark Tableview delegate & data source methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
		[bar setDelegate:self];
		[bar setTintColor:[UIColor colorWithHexString:@"EDEFF4"]];
		[bar setBarStyle:UIBarStyleDefault];
		[bar setPlaceholder:FTLangGet(@"Search friends")];
		return bar;
	}
	else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) return 44;
	else return 16;
}

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
    if (!isSearching) return [[sections allKeys] count];
	else return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!isSearching) return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
	else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!isSearching) return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
	else return [searchArray count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!isSearching) return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	return nil;
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	isSearching = YES;
}


@end
