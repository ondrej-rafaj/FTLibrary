//
//  FTPageScrollViewDelegate.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPage.h"


@class FTPageScrollView;

@protocol FTPageScrollViewDelegate <NSObject>

@required

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount;

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount;

@optional

- (CGSize)pageScrollView:(FTPageScrollView *)scrollView sizeForPage:(CGSize)size;

- (void)pageScrollView:(FTPageScrollView *)scrollView didMakePageCurrent:(FTPage *)page;

- (void)pageScrollView:(FTPageScrollView *)scrollView offsetDidChange:(CGPoint)offset;

- (void)dummyScrollInPageScrollViewDidFinish:(FTPageScrollView *)scrollView;

@end
