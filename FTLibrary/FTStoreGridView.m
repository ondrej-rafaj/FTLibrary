//
//  FTStoreGridView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTStoreGridView.h"
#import "FTSystem.h"
#import "FTStoreHeaderView.h"
#import "UIColor+Tools.h"


@implementation FTStoreGridView

@synthesize grid;
@synthesize delegate;
@synthesize dataSource;


#pragma mark Creating elements

- (void)createMainGridView {
	grid = [[AQGridView alloc] initWithFrame:self.bounds];
	
	// Setting up header view
	CGRect r = grid.bounds;
	r.size.height = 290;
	FTStoreHeaderView *header = [[FTStoreHeaderView alloc] initWithFrame:r];
	[grid setGridHeaderView:header];
	[header release];
	
	// Setting up footer view
	FTStoreHeaderView *footer = [[FTStoreHeaderView alloc] initWithFrame:r];
	[grid setGridFooterView:footer];
	[footer release];
	
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
	if ([dataSource respondsToSelector:@selector(numberOfItemsInStoreGridView:)]) {
		return [dataSource numberOfItemsInStoreGridView:self];
	}
	else return 0;
}

- (FTStoreDataObject *)dataObjectForIndex:(NSInteger)index {
	if ([dataSource respondsToSelector:@selector(storeGridView:dataObjectForItemAtIndex:)]) {
		return [dataSource storeGridView:self dataObjectForItemAtIndex:index];
	}
	else return [[[FTStoreDataObject alloc] init] autorelease];
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView {
	if ([FTSystem isPhoneIdiom]) {
		return CGSizeMake(150, 80);
	}
	else {
		return CGSizeMake(320, 290);
	}
}

- (void)configureGridCell:(FTStoreGridViewCell *)cell atIndex:(NSInteger)index forGridView:(AQGridView *)gridView {
	FTStoreDataObject *o = [self dataObjectForIndex:index];
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
	[cell.imageView loadImageFromUrl:o.imageSUrl];
	[cell setTitleText:o.title];
	[cell setDescriptionText:o.description];
	[cell.price setText:[NSString stringWithFormat:@"£%.2f", [o.price floatValue]]];
	
	[cell setCellIndex:index];
	[cell setDataObject:o];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *ci = @"StoreGridViewCell";
	FTStoreGridViewCell *cell = (FTStoreGridViewCell *)[gridView dequeueReusableCellWithIdentifier:ci];
	if (!cell) {
		CGRect r = CGRectMake(0, 0, 0, 0);
		r.size = [self portraitGridCellSizeForGridView:gridView];
		cell = [[[FTStoreGridViewCell alloc] initWithFrame:r reuseIdentifier:ci] autorelease];
	}
	UIImage *img = nil;
	if ([dataSource respondsToSelector:@selector(defaultCellImageForStoreGridView:)]) {
		img = [dataSource defaultCellImageForStoreGridView:self];
	}
	[cell.imageView setImage:img];
	[self configureGridCell:cell atIndex:index forGridView:grid];
	[cell setDelegate:self];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
//	[gridView deselectItemAtIndex:index animated:NO];
}

#pragma mark Cell delegate methods

- (void)didClickCoverImageWithIndex:(NSInteger)index andObject:(FTStoreDataObject *)dataObject {
	if ([delegate respondsToSelector:@selector(storeGridView:didClickCellWithObject:atIndex:)]) {
		FTStoreDataObject *o = [self dataObjectForIndex:index];
		[delegate storeGridView:self didClickCellWithObject:o atIndex:index];
	}
}

- (void)didClickActionButtonWithIndex:(NSInteger)index withCell:(FTStoreGridViewCell *)cell andObject:(FTStoreDataObject *)dataObject {
	if ([delegate respondsToSelector:@selector(storeGridView:didClickActionButtonWithObject:withCell:atIndex:)]) {
		FTStoreDataObject *o = [self dataObjectForIndex:index];
		[delegate storeGridView:self didClickActionButtonWithObject:o withCell:cell atIndex:index];
	}
}

#pragma mark Setters and getters

- (void)setHeaderImageUrl:(NSString *)headerUrl andFooterImageUrl:(NSString *)footerUrl {
	[[(FTStoreHeaderView *)grid.gridHeaderView imageView] loadImageFromUrl:headerUrl];
	[[(FTStoreHeaderView *)grid.gridFooterView imageView] loadImageFromUrl:footerUrl];
}

- (void)setHeaderImage:(UIImage *)headerImage andFooterImage:(UIImage *)footerImage {
	[[(FTStoreHeaderView *)grid.gridHeaderView imageView] setImage:headerImage];
	[[(FTStoreHeaderView *)grid.gridFooterView imageView] setImage:footerImage];
}

#pragma mark Data management

- (void)reloadData {
	[grid reloadData];
}

#pragma mark Store grid view delegate & datasource methods

- (void)storeGridViewCellRequestedDataReload:(FTStoreGridViewCell *)cell {
	
}

#pragma mark Memory management

- (void)dealloc {
	[grid release];
	[super dealloc];
}


@end
