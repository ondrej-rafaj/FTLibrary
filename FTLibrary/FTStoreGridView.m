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
	[self setBackgroundColor:[UIColor orangeColor]];
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
		return CGSizeMake(300, 200);
	}
}

- (void)configureGridCell:(FTGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView {
	CGFloat m = 6;
	CGFloat h = [cell.contentView height];
	CGFloat side = (h - (2 * m));
	[cell.imageView setFrame:CGRectMake(m, m, side, side)];
	
	[cell.contentView setBackgroundColor:[UIColor randomColor]];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *ci = @"StoreGridViewCell";
	FTGridViewCell *cell = (FTGridViewCell *)[gridView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		CGRect r = CGRectMake(0, 0, 0, 0);
		r.size = [self portraitGridCellSizeForGridView:gridView];
		cell = [[[FTGridViewCell alloc] initWithFrame:r reuseIdentifier:ci] autorelease];
	}
	[cell.imageView setImage:nil];
	[self configureGridCell:cell atIndex:index forGridView:grid];
	return cell;
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
