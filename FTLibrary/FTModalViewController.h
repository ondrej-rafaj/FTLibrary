//
//  FTModalViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 07/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"

@interface FTModalViewController : FTViewController {
	
	UIToolbar *topToolBar;
	UIBarButtonItem *closeButton;
	
	UIView *contentView;
	
}

@property (nonatomic, retain) UIToolbar *topToolBar;
@property (nonatomic, retain) UIBarButtonItem *closeButton;
@property (nonatomic, retain) UIView *contentView;


- (void)closeModalView;

- (void)createTopToolbar;
- (void)createTopToolbarWithCloseButton;


@end
