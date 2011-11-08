//
//  FTStoreGridView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreGridView.h"
#import "FTSystem.h"
#import "UIColor+Tools.h"


@implementation FTStoreGridView

@synthesize grid;
@synthesize delegate;


#pragma mark Creating elements

- (void)createMainGridView {
	grid = [[AQGridView alloc] initWithFrame:self.bounds];
	[grid setSeparatorStyle:AQGridViewCellSeparatorStyleEmptySpace];
	[grid setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[grid setDelegate:self];
	[grid setDataSource:self];
	[self addSubview:grid];
}

- (void)createAllElements {
	[self createMainGridView];
}

- (void)setAllElements {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

#pragma mark View initialization

- (void)initializeView {
	[self setAllElements];
	[self createAllElements];
}

#pragma mark Grid view delegate & data source methods

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
	return 11;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView {
	if ([FTSystem isPhoneIdiom]) {
		return CGSizeMake(150, 80);
	}
	else {
		return CGSizeMake(320, 320);
	}
}

- (void)configureGridCell:(FTStoreGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView {	
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
	//[cell.imageView loadImageFromUrl:@"http://www.gotceleb.com/wp-content/uploads/celebrities/avril-lavigne/maxim-magazine-cover-november-2010-issue-scan/avril-lavigne-maxim-magazine-cover-november-2010-issue-scan-01-530x720.jpg"];
	[cell.imageView loadImageFromUrl:@"http://content.hollywire.com/wp-content/uploads/2010/02/vanity-fair-cover-march-rising-stars-2008.jpg"];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *ci = @"StoreGridViewCell";
	FTStoreGridViewCell *cell = (FTStoreGridViewCell *)[gridView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		CGRect r = CGRectMake(0, 0, 0, 0);
		r.size = [self portraitGridCellSizeForGridView:gridView];
		cell = [[[FTStoreGridViewCell alloc] initWithFrame:r reuseIdentifier:ci] autorelease];
	}
	[cell.imageView setImage:nil];
	[self configureGridCell:cell atIndex:index forGridView:grid];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	[gridView deselectItemAtIndex:index animated:NO];
	if ([delegate respondsToSelector:@selector(storeGridView:didClickCell:atIndex:)]) {
		[delegate storeGridView:self didClickCell:nil atIndex:index];
	}
}

#pragma mark Data management

- (void)reloadData {
	[grid reloadData];
}

#pragma mark Memory management

- (void)dealloc {
	[grid release];
	[super dealloc];
}


@end
