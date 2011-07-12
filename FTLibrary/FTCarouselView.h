//
//  FTCarouselView.h
//
//  Version 1.4
//
//  Created by Nick Lockwood on 01/04/2011.
//  Copyright 2010 Charcoal Design. All rights reserved.
//
//  Get the latest version of FTCarouselView from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#FTCarouselView
//  https://github.com/demosthenese/FTCarouselView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.


#import <QuartzCore/QuartzCore.h>

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import <UIKit/UIKit.h>

#else

#import <Cocoa/Cocoa.h>
typedef NSView UIView;

#endif


typedef enum
{
    FTCarouselViewTypeLinear = 0,
    FTCarouselViewTypeRotary,
    FTCarouselViewTypeInvertedRotary,
    FTCarouselViewTypeCylinder,
    FTCarouselViewTypeInvertedCylinder,
    FTCarouselViewTypeCoverFlow,
    FTCarouselViewTypeCustom
}
FTCarouselViewType;


@protocol FTCarouselViewDataSource, FTCarouselViewDelegate;

@interface FTCarouselView : UIView
#ifdef __i386__
{
    id<FTCarouselViewDelegate> delegate;
    id<FTCarouselViewDataSource> dataSource;
    FTCarouselViewType type;
    float perspective;
    NSInteger numberOfItems;
    NSInteger numberOfPlaceholders;
    NSInteger numberOfVisibleItems;
    UIView *contentView;
    NSDictionary *itemViews;
    NSArray *placeholderViews;
    NSInteger previousItemIndex;
    float itemWidth;
    float scrollOffset;
    float currentVelocity;
    NSTimer *timer;
    NSTimeInterval previousTime;
    BOOL decelerating;
    BOOL scrollEnabled;
    float decelerationRate;
    BOOL bounces;
    CGSize contentOffset;
    CGSize viewpointOffset;
    float startOffset;
    float endOffset;
    NSTimeInterval scrollDuration;
    NSTimeInterval startTime;
    BOOL scrolling;
    float previousTranslation;
	BOOL centerItemWhenSelected;
	BOOL shouldWrap;
	BOOL dragging;
}
#endif

@property (nonatomic, assign) IBOutlet id<FTCarouselViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<FTCarouselViewDelegate> delegate;
@property (nonatomic, assign) FTCarouselViewType type;
@property (nonatomic, assign) float perspective;
@property (nonatomic, assign) float decelerationRate;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, readonly) NSInteger currentItemIndex;
@property (nonatomic, assign) NSInteger numberOfVisibleItems;
@property (nonatomic, retain, readonly) NSSet *visibleViews;
@property (nonatomic, readonly) float itemWidth;
@property (nonatomic, retain, readonly) UIView *contentView;

- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

@property (nonatomic, assign) BOOL centerItemWhenSelected;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;

#endif

@end


@protocol FTCarouselViewDataSource <NSObject>

- (NSUInteger)numberOfItemsInCarousel:(FTCarouselView *)carousel;
- (UIView *)carousel:(FTCarouselView *)carousel viewForItemAtIndex:(NSUInteger)index;

@optional

- (NSUInteger)numberOfPlaceholdersInCarousel:(FTCarouselView *)carousel;
- (UIView *)carousel:(FTCarouselView *)carousel placeholderViewAtIndex:(NSUInteger)index;

@end


@protocol FTCarouselViewDelegate <NSObject>

@optional

- (void)carouselWillBeginScrollingAnimation:(FTCarouselView *)carousel;
- (void)carouselDidEndScrollingAnimation:(FTCarouselView *)carousel;
- (void)carouselDidScroll:(FTCarouselView *)carousel;
- (void)carouselCurrentItemIndexUpdated:(FTCarouselView *)carousel;
- (void)carouselWillBeginDragging:(FTCarouselView *)carousel;
- (void)carouselDidEndDragging:(FTCarouselView *)carousel willDecelerate:(BOOL)decelerate;
- (void)carouselWillBeginDecelerating:(FTCarouselView *)carousel;
- (void)carouselDidEndDecelerating:(FTCarouselView *)carousel;
- (float)carouselItemWidth:(FTCarouselView *)carousel;
- (BOOL)carouselShouldWrap:(FTCarouselView *)carousel;
- (CATransform3D)carousel:(FTCarouselView *)carousel transformForItemView:(UIView *)view withOffset:(float)offset;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

- (void)carousel:(FTCarouselView *)carousel didSelectItemAtIndex:(NSInteger)index;

#endif

@end