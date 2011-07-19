//
//  FTViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"
#import "FTAppDelegate.h"
#import "FTLang.h"


@implementation FTViewController

@synthesize table;
@synthesize data;
@synthesize backgroundView;
@synthesize isLandscape;
@synthesize loadingProgressView;


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
	[loadingProgressView release];
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [data count];
	return count;
}

- (void)configureCell:(FTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	[cell.textLabel setText:@"Fuerte ROCKS !!!"];
	[cell.detailTextLabel setText:@"http://www.fuerteint.com/"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"FTBasicCell";
	FTTableViewCell *cell = (FTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[FTTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Did select row in section %d with index %d and agreed that Fuerte ROCKS !!!", indexPath.section, indexPath.row);
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

#pragma mark Loading progress view

- (void)configureLoadingProgressView {
	[self.view addSubview:loadingProgressView];
	[self.view bringSubviewToFront:loadingProgressView];
	[loadingProgressView setDelegate:self];
}

- (void)enableLoadingProgressViewInWindowWithTitle:(NSString *)title withAnimationStyle:(FTProgressViewAnimation)animation showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	if (!loadingProgressView) {
		loadingProgressView = [[FTProgressView alloc] initWithWindow:[FTAppDelegate window]];
		[self configureLoadingProgressView];
		[loadingProgressView setAnimationType:animation];
		[loadingProgressView setLabelText:title];
		[loadingProgressView showWhileExecuting:method onTarget:target withObject:object animated:animated];
	}
}

- (void)enableLoadingProgressViewInWindowWithTitle:(NSString *)title andAnimationStyle:(FTProgressViewAnimation)animation {
	if (!loadingProgressView) {
		loadingProgressView = [[FTProgressView alloc] initWithWindow:[FTAppDelegate window]];
		[self configureLoadingProgressView];
		[loadingProgressView setLabelText:title];
		[loadingProgressView setAnimationType:animation];
	}
}

- (void)enableLoadingProgressViewWithTitle:(NSString *)title withAnimationStyle:(FTProgressViewAnimation)animation showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	if (!loadingProgressView) {
		loadingProgressView = [[FTProgressView alloc] initWithView:self.view];
		[self configureLoadingProgressView];
		[loadingProgressView setAnimationType:animation];
		[loadingProgressView setLabelText:title];
		[loadingProgressView showWhileExecuting:method onTarget:target withObject:object animated:animated];
	}
}

- (void)enableLoadingProgressViewWithTitle:(NSString *)title andAnimationStyle:(FTProgressViewAnimation)animation {
	if (!loadingProgressView) {
		loadingProgressView = [[FTProgressView alloc] initWithView:self.view];
		[self configureLoadingProgressView];
		[loadingProgressView setLabelText:title];
		[loadingProgressView setAnimationType:animation];
	}
}

- (void)disableLoadingProgressView {
	if (loadingProgressView) {
		[loadingProgressView hide:YES];
	}
}

#pragma mark Translations

- (void)setTitle:(NSString *)title {
	title = FTLangGet(title);
	[super setTitle:title];
}

#pragma mark FTProgressView delegate method

- (void)progressViewHasBeenHidden:(FTProgressView *)progressView {
	[progressView removeFromSuperview];
	[progressView release];
	progressView = nil;
}


@end
