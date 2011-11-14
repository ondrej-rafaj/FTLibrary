//
//  FTUnlimitedGridView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTUnlimitedGridView.h"


#define kFTUnlimitedGridViewInsideSide					8000


@interface FTUnlimitedGridView (Private)
- (CGSize)cellSize;
- (void)enqueueReusableCells:(NSArray *)reusableCells;
@end

@implementation FTUnlimitedGridView

@synthesize mainScrollView;
@synthesize contentView;
@synthesize delegate;
@synthesize dataSource;


#pragma mark Initialization

- (void)initializeView {
	_visibleCells = [[NSMutableArray alloc] init];
	_reusableGridCells = [[NSMutableDictionary alloc] init];
	_cellSize = CGSizeZero;
	
	mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	[mainScrollView setDelegate:self];
	[mainScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[mainScrollView setMinimumZoomScale:1.0f];
	[mainScrollView setMaximumZoomScale:2.0f];
	//[mainScrollView setShowsVerticalScrollIndicator:NO];
	//[mainScrollView setShowsHorizontalScrollIndicator:NO];
	[mainScrollView setContentSize:CGSizeMake(kFTUnlimitedGridViewInsideSide, kFTUnlimitedGridViewInsideSide)];
	CGFloat x = ((kFTUnlimitedGridViewInsideSide / 2) - (self.bounds.size.width / 2));
	CGFloat y = ((kFTUnlimitedGridViewInsideSide / 2) - (self.bounds.size.height / 2));
	[mainScrollView setContentOffset:CGPointMake(x, y)];
	_virtualContentOffset = mainScrollView.contentOffset;
	[self addSubview:mainScrollView];
	
	contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFTUnlimitedGridViewInsideSide, kFTUnlimitedGridViewInsideSide)];
	[contentView setBackgroundColor:[UIColor redColor]];
	[mainScrollView addSubview:contentView];	
}

#pragma mark Data source methods

- (CGRect)frameForCellAtCoordinate:(FTUnlimitedGridViewCellCoordinate)coordinate {
	CGRect r = CGRectZero;
	r.size = [self cellSize];
	r.origin = CGPointMake((coordinate.x * r.size.width), (coordinate.y * r.size.height));
	return r;
}

- (FTUnlimitedGridViewCell *)createPreparedCellForIndex:(FTUnlimitedGridViewCellCoordinate)coordinate {
	[UIView setAnimationsEnabled:NO];
	FTUnlimitedGridViewCell *cell = nil;
	if ([dataSource respondsToSelector:@selector(unlimitedGridView:cellForCoordinate:)]) {
		cell = [dataSource unlimitedGridView:self cellForCoordinate:coordinate];
		if (![_reusableGridCells objectForKey:cell.reuseIdentifier]) {
			//[_reusableGridCells setValue:cell forKey:cell.reuseIdentifier];
		}
	}
	if (cell) {
		[cell setCoordinate:coordinate];
		[cell setFrame:[self frameForCellAtCoordinate:coordinate]];
		[contentView insertSubview:cell atIndex:0];
	}
    [UIView setAnimationsEnabled: YES];
	return cell;
}

#pragma mark Layout

- (CGRect)visibleBounds {
	CGRect r = CGRectZero;
	r.origin = _virtualContentOffset;
	r.size   = mainScrollView.bounds.size;
	
	r.origin.x += 100;
	r.origin.y += 100;
	r.size.width -= 200;
	r.size.height -= 200;
	
	return r;
}

- (void)fillVisibleSpaceWithCells {
	CGSize s = [self cellSize];
	CGRect visibleRect = [self visibleBounds];
	int xs = floor(visibleRect.origin.x / s.width);
	int xe = ceil((visibleRect.origin.x + visibleRect.size.width) / s.width);
	int ys = floor(visibleRect.origin.y / s.height);
	int ye = ceil((visibleRect.origin.y + visibleRect.size.height) / s.height);
	
	
	
	for (int x = xs; x < xe; x++) {
		if (xs < leftColumn || xe > rightColumn) {
			for (int y = ys; y < ye; y++) {
				if (ys < topRow || ye > bottomRow) {
					FTUnlimitedGridViewCellCoordinate c;
					c.x = x;
					c.y = y;
					FTUnlimitedGridViewCell *cell = [self createPreparedCellForIndex:c];
					[_visibleCells addObject:cell];
				}
			}
		}
	}
	
	leftColumn = xs;
	rightColumn = xe;
	topRow = ys;
	bottomRow = ye;
	
	[self enqueueReusableCells:_visibleCells];
	
	NSLog(@"Number of items on view: %d", [contentView.subviews count]);
}

- (CGSize)cellSize {
	if (_cellSize.width == 0 || _cellSize.height == 0) {
		if ([dataSource respondsToSelector:@selector(cellSizeForUnlimitedGridView:)]) {
			_cellSize = [dataSource cellSizeForUnlimitedGridView:self];
		}
	}
	return _cellSize;
}

- (CGRect)rectForItemAtCoordinate:(FTUnlimitedGridViewCellCoordinate)coordinate {
	CGRect r = CGRectZero;
	CGSize s = [self cellSize];
	CGFloat x = (coordinate.x * s.width);
	CGFloat y = (coordinate.y * s.height);
	r.origin = CGPointMake(x, y);
	r.size = s;
	return r;
}

- (FTUnlimitedGridViewCellCoordinate)topLeftCoordinate {
	FTUnlimitedGridViewCellCoordinate c;
	CGSize s = [self cellSize];
	c.x = floor(_virtualContentOffset.x / s.width);
	c.y = floor(_virtualContentOffset.y / s.height);
	return c;
}

- (FTUnlimitedGridViewCellCoordinate)bottomRightCoordinate {
	FTUnlimitedGridViewCellCoordinate c;
	CGSize s = [self cellSize];
	c.x = ceil((_virtualContentOffset.x + s.width) / s.width);
	c.y = ceil((_virtualContentOffset.y + s.height) / s.height);
	return c;
}

#pragma mark Scroll view delegate methods

- (void)resetContentView {
	//CGFloat x = ((kFTUnlimitedGridViewInsideSide / 2) - (self.bounds.size.width / 2));
	//CGFloat y = ((kFTUnlimitedGridViewInsideSide / 2) - (self.bounds.size.height / 2));
	//[mainScrollView setContentOffset:CGPointMake(x, y)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat x = scrollView.contentOffset.x;
	CGFloat y = scrollView.contentOffset.y;
	_virtualContentOffset = CGPointMake(x, y);
	[self resetContentView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		CGFloat x = scrollView.contentOffset.x;
		CGFloat y = scrollView.contentOffset.y;
		_virtualContentOffset = CGPointMake(x, y);
		[self resetContentView];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self fillVisibleSpaceWithCells];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return contentView;
}

#pragma mark Dequeue cells

- (FTUnlimitedGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier {
	//return nil;
	NSMutableSet *cells = [_reusableGridCells objectForKey:reuseIdentifier];
	FTUnlimitedGridViewCell *cell = [[cells anyObject] retain];
	if (cell == nil) return nil;
	[cell prepareForReuse];
	[cells removeObject:cell];
	return [cell autorelease];
}

- (void)enqueueReusableCells:(NSArray *)reusableCells {
	for (FTUnlimitedGridViewCell *cell in reusableCells) {
		NSMutableSet *reuseSet = [_reusableGridCells objectForKey:cell.reuseIdentifier];
		if (reuseSet == nil) {
			reuseSet = [[NSMutableSet alloc] initWithCapacity:32];
			[_reusableGridCells setObject:reuseSet forKey:cell.reuseIdentifier];
			[reuseSet release];
		}
		else if ([reuseSet member:cell] == cell) {
			NSLog( @"Warning: tried to add duplicate gridview cell" );
			continue;
		}
		[reuseSet addObject:cell];
	}
}

- (void)reloadData {
	// remove all existing cells
	[_visibleCells makeObjectsPerformSelector: @selector(removeFromSuperview)];
	[self enqueueReusableCells:_visibleCells];
	[_visibleCells removeAllObjects];
	
	// layout -- no animation
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self fillVisibleSpaceWithCells];
}

#pragma mark Memory management

- (void)dealloc {
	[mainScrollView release];
	[contentView release];
	[_visibleCells release];
	[_reusableGridCells release];
	[super dealloc];
}

@end
