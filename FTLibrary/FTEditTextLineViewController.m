//
//  FTEditTextLineViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTEditTextLineViewController.h"
#import "UILabel+DynamicHeight.h"


@implementation FTEditTextLineViewController

@synthesize textField;
@synthesize descriptionLabel;
@synthesize delegate;


#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 300, 36)];
	[textField setDelegate:self];
	[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[textField setBorderStyle:UITextBorderStyleRoundedRect];
	[textField setReturnKeyType:UIReturnKeyDone];
	[self.view addSubview:textField];
	
	descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 76, 300, 104)];
	[descriptionLabel setBackgroundColor:[UIColor clearColor]];
	[descriptionLabel setFont:[UIFont systemFontOfSize:12]];
	[descriptionLabel setTextColor:[UIColor blackColor]];
	[descriptionLabel setContentMode:UIViewContentModeTop];
	[self.view addSubview:descriptionLabel];
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

#pragma merk Text field delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.navigationController popViewControllerAnimated:YES];
	return YES;
}

#pragma mark Memory management

- (void)dealloc {
	[textField release];
	[descriptionLabel release];
	[super dealloc];
}


@end
