//
//  FTPageScrollView.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPageScrollViewDelegate.h"
#import "FTPage.h"


@interface FTPageScrollView : UIScrollView <UIScrollViewDelegate> {
	
	FTPage *centerPage;	
	FTPage *leftPage;
	FTPage *rightPage;
	FTPage *pendingPage;
	
	UIImage *dummyPageImage;
	
	NSMutableArray *pages;
	
	BOOL moving;
	BOOL enabled;
	BOOL pageSetInProgress;
	
	NSInteger touchCount;
	double verticalOffset;
	
	id <FTPageScrollViewDelegate> pageScrollDelegate;
	
}


@property (nonatomic, readonly) BOOL moving;

@property (nonatomic, retain) UIImage *dummyPageImage;


- (void)setInitialPage:(FTPage *)page withDelegate:(id <FTPageScrollViewDelegate> )aDelegate;

- (void)setPage:(FTPage *)aPage pageCount:(NSInteger)pageCount animate:(BOOL)animate;

- (void)setPage:(FTPage *)aPage;

- (FTPage *)currentPage;

- (void)cancelOperation;

- (void)layout;

- (void)reload;


@end
