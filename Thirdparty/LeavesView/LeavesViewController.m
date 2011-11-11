//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"

@implementation LeavesViewController

@synthesize leavesView;


#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
		leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
        leavesView.mode = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? LeavesViewModeSinglePage : LeavesViewModeFacingPages;
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
	[leavesView release];
    [super dealloc];
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView *)leavesView {
	return 0;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
}

#pragma mark UIViewController methods

- (void)loadView {
	[super loadView];
	leavesView.frame = self.view.bounds;
	leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:leavesView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[leavesView setDataSource:self];
	[leavesView setDelegate:self];
	//[leavesView reloadData];
}

#pragma mark Interface

- (void)doLayoutSubviews {
	if (!isLandscape) {
        [leavesView setMode:LeavesViewModeSinglePage];
    }
	else {
        [leavesView setMode:LeavesViewModeFacingPages];
    }
}


@end