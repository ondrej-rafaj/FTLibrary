//
//  FTPageLocation.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTPageLocation : NSObject {
	
	NSInteger sectionIndex;
	NSInteger articleIndex;
	NSInteger pageIndex;
	
}

@property (nonatomic) NSInteger sectionIndex;
@property (nonatomic) NSInteger articleIndex;
@property (nonatomic) NSInteger pageIndex;


- (id)initWithSectionIndex:(NSInteger)aSectionIndex articleIndex:(NSInteger)anArticleIndex andPageIndex:(NSInteger)aPageIndex;

- (id)initWithPageLocation:(FTPageLocation *)aPageLocation;

- (NSString *)locationKey;

- (BOOL)isSameLocation:(FTPageLocation *)aPageLocation;

- (BOOL)isBeforeLocation:(FTPageLocation *)aPageLocation;

- (BOOL)isAfterLocation:(FTPageLocation *)aPageLocation;


@end
