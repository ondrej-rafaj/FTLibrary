//
//  FTViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "FTViewController.h"
#import "FTAppDelegate.h"
#import "FTLang.h"
#import "FTSystem.h"
#import "FTProject.h"
#import "FTDebugMemoryLabelView.h"


@implementation FTViewController

@synthesize table;
@synthesize data;
@synthesize backgroundView;
@synthesize isLandscape;
@synthesize loadingProgressView;
@synthesize compareDesign;
@synthesize compareDesignView;


#pragma mark Positioning

// TODO: finish me for landscape, portrait, iPhone & iPad :)
- (CGRect)fullscreenRect {
	if ([FTSystem isPhoneSize]) {
//		CGFloat height =	480;	// full height
//		if (YES) height -=	20;		// status bar
//		if (YES) height -=	44;		// navigation bar
//		if (NO) height -=	49;		// tab bar
//		return CGRectMake(0, 0, 320, height);
		if (isLandscape) return CGRectMake(0, 0, 480, 300);
		else return CGRectMake(0, 0, 320, 480);		
	}
	else {
		if (isLandscape) return CGRectMake(0, 0, 1024, 748);
		else return CGRectMake(0, 0, 768, 1004);
	}
}

#pragma mark Initialization

- (void)initializingSequence {
	
}

- (id)init {
	self = [super init];
	if (self) {
		[self initializingSequence];
        self.compareDesign = NO;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initializingSequence];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self initializingSequence];
	}
	return self;
}

#pragma mark Memory management

- (void)dealloc {
    [backgroundView release];
	[table release];
	[data release];
	[debugLabel release];
    [compareDesignView release], compareDesignView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Layout

- (void)doLayoutSubviews {
	
}

- (void)doLayoutAllElements {
	[backgroundView setFrame:[self fullscreenRect]];	
	[self doLayoutSubviews];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	isLandscape = UIInterfaceOrientationIsLandscape([FTSystem interfaceOrientation]);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	isLandscape = UIInterfaceOrientationIsLandscape([FTSystem interfaceOrientation]);
	[self doLayoutAllElements];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (loadingProgressView) {
		//[loadingProgressView hide:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([FTProject memoryDebugging]) {
		if (!debugLabel) debugLabel = [FTDebugMemoryLabelView startWithView:self.view];
		[self.view bringSubviewToFront:debugLabel];
	}
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

- (void)configureCell:(FTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
	[cell.textLabel setText:@"Fuerte ROCKS !!!"];
	[cell.detailTextLabel setText:@"http://www.fuerteint.com/"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"FTBasicCell";
	FTTableViewCell *cell = (FTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[FTTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	[self configureCell:cell atIndexPath:indexPath forTableView:tableView];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Did select row in section %d with index %d and agreed that Fuerte ROCKS !!! Lulz", indexPath.section, indexPath.row);
}

#pragma mark Custom setting background

- (void)setBackgroundWithImageName:(NSString *)imageName {
	if (imageName == nil) {
		if (backgroundView) {
			[backgroundView removeFromSuperview];
			backgroundView = nil;
		}
	}
	
    UIImage *img = [UIImage imageNamed:imageName];
    if (!img) return;
    
    if (backgroundView) {
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    }
    
    backgroundView = [[UIImageView alloc] initWithFrame:[self fullscreenRect]];
    [backgroundView setImage:img];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}

- (UIImageView *)backgroundView
{
	if (backgroundView == nil) {
		if (self.isViewLoaded) {
			backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
			backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			backgroundView.contentMode = UIViewContentModeTopLeft;
			[self.view insertSubview:backgroundView atIndex:0];
		}
		else {
			NSLog(@"FTViewController: you have to access the backgroundView property when the controller's view is loaded! (in -viewDidLoad for example)");
		}
	}
	return backgroundView;
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
	if (loadingProgressView) {
		loadingProgressView = nil;
	}
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
	self.loadingProgressView = nil;
}

#pragma mark comapare Design custom setter

- (void)setCompareDesign:(BOOL)acompareDesign {
    compareDesign = acompareDesign;
    if (compareDesign) {
        if (!self.compareDesignView) {
            compareDesignView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:self.compareDesignView];
            [self.compareDesignView setAlpha:0.4];
        }
        const char* classChar = class_getName([self class]);
        NSString *imgName = [NSString stringWithFormat:@"%s.png", classChar];
        
        UIImage *img = [UIImage imageNamed:imgName];
        if (img) {
            [self.compareDesignView setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
            [self.compareDesignView setImage:img];
            [self.compareDesignView.layer setZPosition:0];
            NSLog(@"Load Design Comparison %@", imgName);
        }
        else {
            NSLog(@"Image for class %@ not found!", imgName);
        }
    }
}

#pragma mark Translations

- (void)setTitle:(NSString *)title {
	title = FTLangGet(title);
	[super setTitle:title];
}

- (void)setTitleWithNoTranslation:(NSString *)title {
	[super setTitle:title];
}

#pragma mark FTProgressView delegate method

- (void)progressViewHasBeenHidden:(FTProgressView *)progressView {
	[progressView removeFromSuperview];
	[progressView release];
	progressView = nil;
}


@end
