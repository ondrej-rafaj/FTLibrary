//
//  FTPageScrollView2.h
//  FTLibrary
//
//  Created by Baldoph Pourprix on 16/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 - provides actual lazy loading
 - easy to use
 - soft
 - incredibly sexy
 */

@class FTPageScrollView2;

@protocol FTPageScrollView2DataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPageScrollView:(FTPageScrollView2 *)scrollView;
@optional
//one of the two following methods is required but not both
//display an image
- (UIImage *)scrollView:(FTPageScrollView2 *)scrollView imageForPageAtIndex:(NSInteger)index;
//the property reusedView contained a reused view of the same class as the one you returned before
- (UIView *)scrollView:(FTPageScrollView2 *)scrollView viewForPageAtIndex:(NSInteger)index reusedView:(UIView *)view;
@end


@protocol FTPageScrollView2Delegate <NSObject, UIScrollViewDelegate>
@optional
//the view at index 'index' received a touch
- (void)scrollView:(FTPageScrollView2 *)scrollView didSelectView:(UIView *)view atIndex:(NSInteger)index;
- (void)scrollView:(FTPageScrollView2 *)scrollView didSlideToIndex:(NSInteger)index;
@end


@interface FTPageScrollView2 : UIScrollView {
	
	NSMutableArray *_visibleViews;
	NSMutableSet *_reusableViews;
	NSMutableSet *_reusableContainers;
	NSInteger _numberOfPages;
	CGSize _visibleSize;
	BOOL _dataSourceProvidesViews;
	CGRect _varianceRect;
	CGFloat _horizontalMarginWidth;
	id <FTPageScrollView2Delegate> _pageScrollViewDelegate;
	CGFloat _visibleHorizontalPadding;
}

@property (nonatomic, assign) id <FTPageScrollView2DataSource> dataSource;
@property (nonatomic, assign) id <FTPageScrollView2Delegate> delegate;
@property (nonatomic, assign) CGSize visibleSize;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;

- (void)reloadData;
- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (NSInteger)selectedIndex;
- (UIView *)selectedView;

@end
