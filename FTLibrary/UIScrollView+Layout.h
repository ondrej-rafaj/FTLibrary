//
//  UIScrollView+Layout.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIScrollView (Layout)

- (void)setContentWidth:(double)aWidth;
- (void)setContentHeight:(double)aHeight;
- (void)setContentWidthTimes:(NSInteger)times;
- (void)setContentHeightTimes:(NSInteger)times;
- (void)scrollContentToLeft;
- (void)scrollContentToXPosition:(double)xPosition;

@end
