//
//  FTModalViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 07/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTModalViewController.h"
#import "FTSystem.h"
#import "FTLang.h"
#import "UIView+Layout.h"


@implementation FTModalViewController

@synthesize topToolBar;
@synthesize closeButton;
@synthesize contentView;


#pragma mark Button actions

- (void)closeModalView {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Creating elements

- (void)createTopToolbar {
	topToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [self.view width], 44)];
	[topToolBar setBarStyle:UIBarStyleBlackOpaque];
	[topToolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:topToolBar];
	
	[contentView setAutoresizingMask:UIViewAutoresizingNone];
	CGRect r = contentView.bounds;
	r.origin.y += [topToolBar height];
	r.size.height -= [topToolBar height];
	[contentView setFrame:r];
	[contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)createTopToolbarWithCloseButton {
	[self createTopToolbar];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:item];
	
	item = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Close") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)];
	[items addObject:item];
	
	[topToolBar setItems:items];
	[items release];
}

- (void)createContentView {
	contentView = [[UIView alloc] initWithFrame:self.view.bounds];
	[contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[contentView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:contentView];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createContentView];
}

#pragma mark Initialization

- (void)setupModalView {
	[self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	if ([FTSystem isTabletIdiom]) [self setModalPresentationStyle:UIModalPresentationFormSheet];
}

- (id)init {
	self = [super init];
	if (self) {
		[self setupModalView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupModalView];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self setupModalView];
	}
	return self;
}

#pragma mark Memory management

- (void)dealloc {
	[topToolBar release];
	[closeButton release];
	[contentView release];
	[super dealloc];
}


@end
