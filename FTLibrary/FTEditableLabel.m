//
//  FTEditableLabel.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTEditableLabel.h"


@implementation FTEditableLabel

@synthesize animateEditToggle;


#pragma mark Initialization

- (void)setupElement {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	[label setTextColor:[UIColor blackColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[self addSubview:label];
	
	CGRect r = self.bounds;
	r.origin.y += 1;
	r.size.height -= 1;
	input = [[UITextField alloc] initWithFrame:r];
	[input setDelegate:self];
	[input setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[input setTextColor:[UIColor blackColor]];
	[input setBackgroundColor:[UIColor clearColor]];
	[input setHidden:YES];
	[self addSubview:input];
	
	[self setBackgroundColor:[UIColor whiteColor]];
	
	[self setAnimateEditToggle:NO];
}

#pragma mark Edit mode configuration

- (void)syncTextBackToLabel {
	[label setText:input.text];
}

- (void)finishEditingWithAnimation:(BOOL)animation {
	if ([super isEditMode]) {
		[label setHidden:YES];
		[input becomeFirstResponder];
		if (animation) [UIView beginAnimations:nil context:nil];
		[input setAlpha:1];
	}
	else {
		[input setHidden:YES];
		if (animation) [UIView beginAnimations:nil context:nil];
		[label setAlpha:1];
	}
	if (animation) {
		[UIView setAnimationDuration:0.2];
		[UIView commitAnimations];
	}
}

- (void)finishEditing {
	[self finishEditingWithAnimation:YES];
}

- (void)configureForEditMode:(BOOL)isEditting {
	if (animateEditToggle) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishEditing)];
		[UIView setAnimationDuration:0.2];
	}
	if (isEditting) {
		[input setHidden:NO];
		[label setAlpha:0];
	}
	else {
		[self syncTextBackToLabel];
		[label setHidden:NO];
		[input setAlpha:0];
	}
	if (animateEditToggle) [UIView commitAnimations];
	else [self finishEditingWithAnimation:NO];
}

#pragma mark Settings

- (void)setText:(NSString *)text {
	[label setText:text];
	[input setText:text];
}

- (void)setTextColor:(UIColor *)color {
	[label setTextColor:color];
	[input setTextColor:color];
}

- (void)setTextAlignment:(UITextAlignment)alignment {
	[label setTextAlignment:alignment];
	[input setTextAlignment:alignment];
}

- (void)setFont:(UIFont *)font {
	[label setFont:font];
	[input setFont:font];
}

-(void)setBackgroundColorForAllElements:(UIColor *)color {
	[label setBackgroundColor:color];
	[input setBackgroundColor:color];
	[self setBackgroundColor:color];
}

#pragma mark Text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
	[super stopEditing];
	return YES;
}

#pragma mark Memory management

- (void)dealloc {
	[label release];
	[input release];
    [super dealloc];
}

@end
