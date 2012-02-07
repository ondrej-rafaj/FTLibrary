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
#import "UIView+Layout.h"
#import "UIColor+Tools.h"
#import "UIAlertView+Tools.h"


@implementation FTFacebookFriendsViewController


#pragma mark Data handling

- (void)startDownloadingDataForCurrentPage {
	NSString *url = [[super facebook] urlWithGraphPath:@"me/friends" andParams:[NSMutableDictionary dictionary]];
	[super downloadDataFromUrl:url];
}

- (void)setMyInfo:(NSDictionary *)info {
	// Flurry
	[FTTracking logFacebookUserInfo:info];
	
	// Setting informations about myself
	NSString *sectionChar = @"«";
	[sections setValue:[NSMutableArray array] forKey:sectionChar];
	NSMutableDictionary *me = [NSMutableDictionary dictionary];
	[me setValue:[info objectForKey:@"id"] forKey:@"id"];
	[me setValue:[NSString stringWithFormat:@"%@ (%@)", [info objectForKey:@"name"], FTLangGet(@"me")] forKey:@"name"];
	[[sections objectForKey:sectionChar] addObject:me];
	// Sorting sections
	for (NSString *key in [sections allKeys]) {
		NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		[[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
		[descriptor release];
	}
	[table reloadData];
}

- (void)downloadMyInfo {
	NSString *url = [[super facebook] urlWithGraphPath:@"me" andParams:[NSMutableDictionary dictionary]];
	myInfoDownload = [[FTDownload alloc] initWithPath:url];
	[myInfoDownload cachingEnabled:YES];
	[myInfoDownload setDelegate:self];
	[myInfoDownload startDownload];
}

- (void)downloadFinishedWithResult:(NSString *)result {
	//NSLog(@"My friends: %@", result);

	NSDictionary *d = [result JSONValue];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:[d objectForKey:@"data"]];
	[super setData:arr];
	
	// Creating index sections
	[sections release];
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
		
	// Adding friends to appropriate sections
	for (NSDictionary *friend in arr) {
		[[sections objectForKey:[[friend objectForKey:@"name"] substringToIndex:1]] addObject:friend];
	}

	// Sorting sections
	for (NSString *key in [sections allKeys]) {
		NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		[[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
		[descriptor release];
	}
	[table reloadData];
	
	if (myInfo) {
		[self setMyInfo:myInfo];
	}
	else [self downloadMyInfo];
}

- (void)reloadData {
//	NSString *cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsList.cache"];
//	[FTFilesystemIO deleteFile:cacheFile];
//	cacheFile = [[FTFilesystemPaths getCacheDirectoryPath] stringByAppendingPathComponent:@"friendsSortedArray.cache"];
//	[FTFilesystemIO deleteFile:cacheFile];
	[self startDownloadingDataForCurrentPage];
	[self downloadMyInfo];
}

- (void)downloadStatusChanged:(FTDownloadStatus)downloadStatus forObject:(FTDownload *)object {
	if (object == myInfoDownload) {
		if (downloadStatus == FTDownloadStatusSuccessful) {
			[self setMyInfo:[object.downloadRequest.responseString JSONValue]];
		}
		else if (downloadStatus == FTDownloadStatusFailed) {
			[UIAlertView showMessage:FTLangGet(@"Error while downloading user data") withTitle:FTLangGet(@"Error")];
		}
	}
	else [super downloadStatusChanged:downloadStatus forObject:object];
}

- (NSDictionary *)dictionaryForFriendAtIndexPath:(NSIndexPath *)indexPath {
	if (!isSearching) return (NSDictionary *)[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	else return [searchArray objectAtIndex:indexPath.row];
}

#pragma mark Memory management

- (void)dealloc {
	[sections release];
	[searchArray release];
	[myInfoDownload release];
	[myInfo release];
	[super dealloc];
}

#pragma mark View lifecycle

- (void)closeFBController {
	[self dismissModalViewControllerAnimated:YES];
	if ([delegate respondsToSelector:@selector(facebookViewControllerDidCancel:)]) {
		[delegate facebookViewControllerDidCancel:self];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	searchArray = [[NSMutableArray alloc] init];
	
	[super createTableView];
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[searchBar setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
	[searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[searchBar setDelegate:self];
	[searchBar setTintColor:[UIColor colorWithHexString:@"EDEFF4"]];
	[searchBar setBarStyle:UIBarStyleDefault];
	[searchBar setPlaceholder:FTLangGet(@"Search friends")];
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[v setBackgroundColor:[UIColor redColor]];
	[v addSubview:searchBar];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:v];
	
	[table setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	if ([FTSystem isPhoneIdiom]) {
		UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(closeFBController)];
		[self.navigationItem setLeftBarButtonItem:close];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Tableview delegate & data source methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) return 0;
	else return 20;
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

#pragma mark Search bar delegate methods

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText {
	if ([searchText length] > 0) {
		if (!isSearching) [_searchBar setShowsCancelButton:YES animated:YES];
		isSearching = YES;
		NSArray *sourceArray;
		if (([searchText length] > lastSearchCharCount) && ([searchArray count] > 0)) {
			sourceArray = [NSArray arrayWithArray:searchArray];
		}
		else {
			sourceArray = [NSArray arrayWithArray:data];
		}
		[searchArray removeAllObjects];
		for (NSDictionary *d in sourceArray) {
			NSRange textRange = [(NSString *)[d objectForKey:@"name"] rangeOfString:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)];
			BOOL fits = (textRange.location != NSNotFound);
			if (fits) [searchArray addObject:d];
		}
		NSLog(@"Searched data: %@", searchArray);
	}
	else {
		if (isSearching) [_searchBar setShowsCancelButton:NO animated:YES];
		isSearching = NO;
	}
	[table reloadData];
	lastSearchCharCount = [searchText length];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
	[_searchBar resignFirstResponder];
	[_searchBar setText:@""];
	[self searchBar:_searchBar textDidChange:@""];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar {
	[_searchBar resignFirstResponder];
	[_searchBar setShowsCancelButton:NO animated:YES];
}

@end
