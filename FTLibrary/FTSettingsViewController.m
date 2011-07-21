//
//  FTSettingsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTSettingsViewController.h"


@implementation FTSettingsViewController


#pragma mark View delegate methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[super createTableView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
