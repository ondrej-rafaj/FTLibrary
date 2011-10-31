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


@implementation FTFacebookFriendsViewController


#pragma mark Data handling

- (void)reloadData {
	Facebook *fb = [super facebook];
	if (![fb isSessionValid]) {
		NSLog(@"Invalid session!!!!");
		[fb authorize:[NSArray arrayWithObjects:@"publish_stream", @"read_stream", @"read_friendlists", @"read_insights", @"user_birthday", @"user_about_me", nil]];
	}
	else {
		NSLog(@"Session is valid!!! :)");
	}
	
	NSString *url = [fb urlWithGraphPath:@"me/friends" andParams:[NSMutableDictionary dictionary]];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:[[FTDataJson jsonDataFromUrl:url] objectForKey:@"data"]];
	
	// Creating index sections
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
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
	
	// Adding friends to appropriate sections
	for (NSDictionary *friend in arr) {
        [[sections objectForKey:[[friend objectForKey:@"name"] substringToIndex:1]] addObject:friend];
    }
	
	// Sorting sections
	for (NSString *key in [sections allKeys]) {
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
	
	[table reloadData];
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
	
//	if(data == nil) {
//		NSArray* users = result;
//		data = [[NSArray alloc] initWithArray: users];
//		for(NSInteger i=0 ;i < [users count]; i++) {
//			NSDictionary *user = [users objectAtIndex:i];
//			NSString *uid = [user objectForKey:@"uid"];
//			NSString *fql = [NSString stringWithFormat:@"select name from user where uid == %@", uid];
//			
//			NSDictionary *params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
//			[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
//			[FBRequest getRequestWithParams:params httpMethod:@"POST" delegate:self requestURL:<#(NSString *)#>
//		}
//	}
//	else {
//		NSArray* users = result;
//		NSDictionary* user = [users objectAtIndex:0];
//		NSString* name = [user objectForKey:@"name"];
//		txtView.text=[NSString localizedStringWithFormat:@"%@%@,\n",txtView.text,name];
//	}
}

- (void)facebookDidPost:(NSError *)error {
	NSLog(@"facebookDidPost:");
}

- (void)facebookDidLogin:(NSError *)error {
	NSLog(@"facebookDidLogin:");
}


@end
