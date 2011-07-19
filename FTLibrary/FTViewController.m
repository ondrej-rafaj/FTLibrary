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
@synthesize backgroundView;
@synthesize isLandscape;


#pragma mark Positioning

// TODO: finish me for landscape, portrait, iPhone & iPad :)
- (CGRect)fullscreenRect {
	CGFloat height =	480;	// full height
	if (YES) height -=	20;		// status bar
	if (YES) height -=	44;		// navigation bar
	if (NO) height -=	49;		// tab bar
	return CGRectMake(0, 0, 320, height);
}

#pragma mark Memory management

- (void)dealloc {
    [backgroundView release];
	[table release];
	[data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Layout

- (void)doLayoutSubviews {
	
}

- (void)doLayoutAllElements {
	[self doLayoutSubviews];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	isLandscape = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	isLandscape = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
	[self doLayoutAllElements];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
	[self doLayoutAllElements];
}

#pragma mark Creating table view

- (void)createTableViewWithStyle:(UITableViewStyle)style andAddToTheMainView:(BOOL)addToView {
	table = [[UITableView alloc] initWithFrame:[self fullscreenRect] style:style];
	[table setDelegate:self];
	[table setDataSource:self];
	if (addToView) [self.view addSubview:table];
}

- (void)createTableViewWithStyle:(UITableViewStyle)style {
	[self createTableViewWithStyle:style andAddToTheMainView:YES];
}

- (void)createTableView {
	[self createTableViewWithStyle:UITableViewStylePlain andAddToTheMainView:YES];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [data count];
}

- (void)configureCell:(FTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"FTBasicCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Did select row in section %d with index: %d", indexPath.section, indexPath.row);
}

#pragma mark Custom setting background

- (void)setBackgroundWithImageName:(NSString *)imageName {
    UIImage *img = [UIImage imageNamed:imageName];
    if (!img) return;
    
    if (backgroundView) {
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    }
    
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundView setImage:img];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}


@end
