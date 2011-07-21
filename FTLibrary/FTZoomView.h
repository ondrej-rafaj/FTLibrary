//
//  FTZoomView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 07/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTZoomView : UIScrollView <UIScrollViewDelegate> {
    
	UIView *zoomedView;
	
}

@property (nonatomic, retain) UIView *zoomedView;


- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin;

- (void)addZoomedView:(UIView *)view;


@end
