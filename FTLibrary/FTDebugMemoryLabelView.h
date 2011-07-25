//
//  FTDebugMemoryLabelView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 25/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTDebugMemoryLabelView : UIView {
	
	UILabel *label;
	
	NSTimer *timer;
	
}

+ (id)start;

+ (id)startIfDebug;

+ (void)startWithView:(UIView *)view;

//+ (void)startWithWindow:(UIWindow *)window;


@end
