//
//  FTPageScrollView2.m
//  FTLibrary
//
//  Created by Baldoph Pourprix on 16/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTPageScrollView2.h"
#import "UIView+Layout.h"

#define SCROLL_VIEW_WIDTH_FT self.bounds.size.width
#define SCROLL_VIEW_HEIGHT_FT self.bounds.size.height

@interface FTPageView2 : UIView
@property (nonatomic, assign) NSUInteger index;
@end

@implementation FTPageView2
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

@end

@interface FTPageScrollView2 () <UIScrollViewDelegate>
- (void)_updateUIForCurrentHorizontalOffset;
- (void)_doLayout;
- (FTPageView2 *)_viewForIndex:(NSInteger)index;
- (void)_disposeOfView:(FTPageView2 *)pageView;
@end

@implementation FTPageScrollView2

@synthesize delegate;
@synthesize dataSource = _dataSource;
@synthesize visibleSize = _visibleSize;
@synthesize horizontalMarginWidth = _horizontalMarginWidth;

#pragma mark - UI Handling

- (void)reloadData
{
	_numberOfPages = [_dataSource numberOfPagesInPageScrollView:self];
	if (_numberOfPages > 0) {
		self.contentSize = CGSizeMake(_numberOfPages * SCROLL_VIEW_WIDTH_FT, SCROLL_VIEW_HEIGHT_FT);
		
		if (_visibleViews == nil) { 
			_visibleViews = [NSMutableArray new];
		}
		
		[self _doLayout];
	}
}

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	CGFloat xOffset = index * self.bounds.size.width;
	//TODO: enable scrolling animation
	_delegate = nil;
	[self setContentOffset:CGPointMake(xOffset, 0) animated:NO];
	_delegate = self;
	[self _doLayout];
}

- (FTPageView2 *)_viewForIndex:(NSInteger)index
{
	UIView *finalView = nil;
	
	if (!_dataSourceProvidesViews) {
		UIImageView *reusedImageView = [_reusableViews anyObject];
		if (reusedImageView == nil) {
			reusedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			reusedImageView.userInteractionEnabled = YES;
		}
		else {
			[reusedImageView retain];
			[_reusableViews removeObject:reusedImageView];
		}
		UIImage *buttonImage = [_dataSource scrollView:self imageForPageAtIndex:index];
		[reusedImageView setImage:buttonImage];
		[reusedImageView sizeToFit];
		finalView = reusedImageView;
	}
	else {
		UIView *reusedView = [_reusableViews anyObject];
		reusedView = [_dataSource scrollView:self viewForPageAtIndex:index reusedView:reusedView];		
		finalView = [reusedView retain];
		[_reusableViews removeObject:reusedView];
	}
	
	FTPageView2 *containerView = [_reusableContainers anyObject];
	if (containerView == nil) {
		containerView = [[FTPageView2 alloc] initWithFrame:self.bounds];
	}
	else {
		[containerView retain];
		[_reusableContainers removeObject:_reusableContainers];
	}
	
	[containerView positionAtX:_horizontalMarginWidth + index * SCROLL_VIEW_WIDTH_FT];
	containerView.index = index;
	[containerView addSubview:finalView];
	[finalView centerInSuperView];
	[finalView release];
	
	return [containerView autorelease];
}

- (void)_updateUIForCurrentHorizontalOffset
{
	CGFloat offset = self.contentOffset.x;
	if (offset < SCROLL_VIEW_WIDTH_FT * (_numberOfPages - 1)) {
		//first view
		FTPageView2 *firstView = [_visibleViews objectAtIndex:0];
		CGRect firstViewFrame = firstView.frame;
		CGFloat firstFloorLimit = firstViewFrame.origin.x;
		
		CGFloat firstCeilLimit = firstViewFrame.origin.x + firstViewFrame.size.width;
		if (offset <= firstFloorLimit - _horizontalMarginWidth + _visibleHorizontalPadding) {
			// we load a view before this one
			if (firstView.index > 0) {
				//we can load a view before the current first one
				FTPageView2 *newView = [self _viewForIndex:firstView.index - 1];
				[self addSubview:newView];
				[_visibleViews insertObject:newView atIndex:0];
			}
		}
		else if (offset >= firstCeilLimit + _visibleHorizontalPadding + _horizontalMarginWidth) {
			//we remove this view
			[self _disposeOfView:firstView];
		}
	}
	if (offset > 0) {
		//last view
		FTPageView2 *lastView = [_visibleViews lastObject];
		CGRect lastViewFrame = lastView.frame;
		CGFloat lastFloorLimit = lastViewFrame.origin.x;
		//CGFloat lastCeilLimit = lastViewFrame.origin.x + lastViewFrame.size.width;
		if (offset >= lastFloorLimit - _visibleHorizontalPadding - _horizontalMarginWidth) {
			// we load a view after this one
			if (lastView.index < _numberOfPages - 1) {
				//we can load a view after the current last one
				FTPageView2 *newView = [self _viewForIndex:lastView.tag + 1];
				[self addSubview:newView];
				[_visibleViews addObject:newView];
			}
		}
		else if (offset <= lastFloorLimit - _visibleHorizontalPadding - _horizontalMarginWidth - self.frame.size.width) {
			[self _disposeOfView:lastView];
		}
	}
}
			 
- (void)_disposeOfView:(FTPageView2 *)pageView
{
	[pageView removeFromSuperview];
	UIView *contentView = pageView.subviews.lastObject;
	[_reusableViews addObject:contentView];
	[contentView removeFromSuperview];
	[_reusableContainers addObject:pageView];
	[_visibleViews removeObjectAtIndex:0];
}

- (void)_doLayout {
	
	for (int i = 0; i < [_visibleViews count]; i++) {
		UIView *v = [_visibleViews lastObject];
		[v removeFromSuperview];
		[_reusableViews addObject:v];
		[_visibleViews removeLastObject];
	}
	
	NSInteger currentPageIndex = self.contentOffset.x / SCROLL_VIEW_WIDTH_FT;
	
	[self scrollViewDidEndDecelerating:self];
	
	NSInteger startIndex = (currentPageIndex <= 0) ? 0 : currentPageIndex - 1;
	NSInteger endIndex = (currentPageIndex + 1 >= _numberOfPages) ? currentPageIndex : currentPageIndex + 1;
	for (int i = startIndex; i <= endIndex; i++) {
		UIView *v = [self _viewForIndex:i];
		[self addSubview:v];
		[_visibleViews addObject:v];
	}
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	_varianceRect = CGRectMake(startPoint.x, startPoint.y, 0, 0);
	
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGRect newRect = CGRectMake(point.x, point.y, 0, 0);
	_varianceRect = CGRectUnion(_varianceRect, newRect);
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGRect newRect = CGRectMake(point.x, point.y, 0, 0);
	_varianceRect = CGRectUnion(_varianceRect, newRect);
	
	if (_varianceRect.size.height < 20 && _varianceRect.size.width < 20) {
		
		for (UIView *v in _visibleViews) {
			if (CGRectContainsPoint(v.frame, point)) {
				if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollView:didSelectView:atIndex:)]) {
					[_pageScrollViewDelegate scrollView:self didSelectView:v atIndex:v.tag];
				}
				break;
			}
		}
	}
	[super touchesEnded:touches withEvent:event];
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.pagingEnabled = YES;
		self.clipsToBounds = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.delaysContentTouches = YES;
		self.canCancelContentTouches = YES;
		_delegate = self;
		self.scrollsToTop = NO;
		self.visibleSize = frame.size;
		_numberOfPages = -1;
		_dataSourceProvidesViews = NO;
		_horizontalMarginWidth = 5;
		_reusableViews = [NSMutableSet new];
		_reusableContainers = [NSMutableSet new];
	}
	return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	if (_numberOfPages == -1 && newSuperview) {
		[self reloadData];
	}
}

- (void)dealloc
{
	[_visibleViews release];
	[_reusableViews release];
	[_reusableContainers release];
	[super dealloc];
}

#pragma mark - Getters

- (NSInteger)selectedIndex
{
    NSInteger index = self.contentOffset.x / self.bounds.size.width;
    if (index < 0) index = 0;
    if (index > _numberOfPages - 1) index = _numberOfPages - 1;
    return index;
}

- (UIView *)selectedView
{
	NSInteger index = [self selectedIndex];
	for (UIView *v in _visibleViews) {
		if (v.tag == index) return v;
	}
	return nil;
}

- (id <FTPageScrollView2Delegate>)delegate
{
	return _pageScrollViewDelegate;
}

#pragma mark - Setters

- (void)setVisibleSize:(CGSize)size
{
	_visibleSize = size;
	_visibleHorizontalPadding = (size.width - self.frame.size.width) / 2 + 10;
}

- (void)setDataSource:(id <FTPageScrollView2DataSource>)d
{
	_dataSource = d;
	if ([_dataSource respondsToSelector:@selector(scrollView:viewForPageAtIndex:reusedView:)]) {
		_dataSourceProvidesViews = YES;
	}
	else {
		_dataSourceProvidesViews = NO;
	}
}

- (void)setDelegate:(id<FTPageScrollView2Delegate>)d
{
	_pageScrollViewDelegate = d;
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self _updateUIForCurrentHorizontalOffset];
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[_pageScrollViewDelegate scrollViewDidScroll:self];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollView:didSlideToIndex:)]) {
		[_pageScrollViewDelegate scrollView:self didSlideToIndex:[self selectedIndex]];
	}
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
		[_pageScrollViewDelegate scrollViewDidEndDecelerating:self];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
		[_pageScrollViewDelegate scrollViewWillBeginDragging:scrollView];
	}
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
		[_pageScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		[_pageScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
		[_pageScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if ([_pageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
		[_pageScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
	}
}

@end