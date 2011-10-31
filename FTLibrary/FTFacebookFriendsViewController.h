//
//  FTFacebookFriendsViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 31/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTFacebookViewController.h"

@interface FTFacebookFriendsViewController : FTFacebookViewController {
	
	NSMutableDictionary *sections;
	
}

- (NSDictionary *)dictionaryForFriendAtIndexPath:(NSIndexPath *)indexPath;


@end
