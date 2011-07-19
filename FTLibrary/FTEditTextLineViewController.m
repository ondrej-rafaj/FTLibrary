//
//  FTEditTextLineViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTEditTextLineViewController.h"


@implementation FTEditTextLineViewController

@synthesize textField;
@synthesize delegate;


#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if ([delegate respondsToSelector:@selector(editTextLineController:didFinishedEditingWithString:)]) {
		[delegate editTextLineController:self didFinishedEditingWithString:textField.text];
	}
}

#pragma mark Memory management

- (void)dealloc {
	[textField release];
	[super dealloc];
}


@end
