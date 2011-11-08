//
//  FTModalFormViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 07/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTModalFormViewController.h"
#import "FTSystem.h"


@implementation FTModalFormViewController


#pragma mark Positioning

- (CGRect)fullscreenRect {
	if ([FTSystem isTabletIdiom]) return CGRectMake(0, 0, 540, 620);
	else {
		if (isLandscape) return CGRectMake(0, 0, 480, 300);
		else return CGRectMake(0, 0, 320, 460);
	}
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
