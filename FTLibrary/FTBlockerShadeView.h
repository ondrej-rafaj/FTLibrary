//
//  FTBlockerShadeView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 11/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTBlockerShadeView : UIView {
    
	BOOL isAnimated;
	
}


- (void)show:(BOOL)animated;

- (void)show;

- (void)hide;


@end
