//
//  UIScrollView+Layout.m
//  FTLibrary
//
//  Created by Fuerte on 25/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UIScrollView+Layout.h"


@implementation UIScrollView (Layout)

- (void) setContentWidth:(double)aWidth {
	CGSize newContentSize = [self contentSize];
	newContentSize.width = aWidth;
	[self setContentSize:newContentSize];
}

- (void) setContentHeight:(double)aHeight {
	CGSize newContentSize = [self contentSize];
	newContentSize.height = aHeight;
	[self setContentSize:newContentSize];	
}

- (void) scrollContentToLeft {
	[self scrollContentToXPosition:0];
}

- (void) scrollContentToXPosition:(double)xPosition {
	CGPoint offset = [self contentOffset];
	offset.x = xPosition;
	[self setContentOffset:offset];
}

@end
