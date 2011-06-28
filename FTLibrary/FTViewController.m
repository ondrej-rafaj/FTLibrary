//
//  FTViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"


@implementation FTViewController

@synthesize table;
@synthesize data;


#pragma mark Positioning

- (CGRect)fullscreenRect {
	return CGRectZero;
}

#pragma mark Memory management

- (void)dealloc {
	[table release];
	[data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
