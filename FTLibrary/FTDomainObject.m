//
//  FTDomainObject.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "FTDomainObject.h"


@implementation FTDomainObject

#define kField_Index	@"index"

// Override this method to return the name of your entity. This makes CoreData calls much simpler and safer.
+ (NSString *)entityName {
	return nil;
}

// Adds the current object to the specified context
- (void)addToContext:(NSManagedObjectContext *)context {
	[context insertObject:self];
}

// If the current object contains an index field, this returns a sorted version of the specified set
- (NSArray *)sortedSet:(NSSet *)aSet {
	if([[aSet.anyObject allKeys] containsObject:kField_Index]) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kField_Index ascending:TRUE];
		NSArray *sortedSet = [[aSet allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
	
		return sortedSet;
	}
	
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
