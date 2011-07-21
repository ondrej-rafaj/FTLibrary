//
//  FTPageLocation.m
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPageLocation.h"


@implementation FTPageLocation

@synthesize sectionIndex;
@synthesize articleIndex;
@synthesize pageIndex;


#pragma mark Initialization

- (id)initWithSectionIndex:(NSInteger)aSectionIndex articleIndex:(NSInteger)anArticleIndex
			   andPageIndex:(NSInteger)aPageIndex {
	self = [super init];
	
	if(self != nil) {
		sectionIndex = aSectionIndex;
		articleIndex = anArticleIndex;
		pageIndex = aPageIndex;
	}
	
	return self;
}

- (id)initWithPageLocation:(FTPageLocation *)aPageLocation {
	return [self initWithSectionIndex:aPageLocation.sectionIndex 
						 articleIndex:aPageLocation.articleIndex andPageIndex:aPageLocation.pageIndex];
}

#pragma mark Memory management

- (void)dealloc {
	[super dealloc];
}

#pragma mark Get, Set methods
 
- (NSString *)locationKey {
	return [NSString stringWithFormat:@"%d:%d:%d", sectionIndex, articleIndex, pageIndex];
}

- (BOOL)isSameLocation:(FTPageLocation *)aPageLocation {
	return self.sectionIndex == aPageLocation.sectionIndex &&
		self.articleIndex == aPageLocation.articleIndex &&
		self.pageIndex == aPageLocation.pageIndex;
}

- (BOOL)isBeforeLocation:(FTPageLocation *)aPageLocation {
	return [self hash] < [aPageLocation hash];
}

- (BOOL)isAfterLocation:(FTPageLocation *)aPageLocation {
	return [self hash] > [aPageLocation hash];
}

- (NSUInteger)hash {
	NSUInteger value = (self.sectionIndex << 16) + (self.articleIndex << 8) + self.pageIndex;
	return value;
}


@end
