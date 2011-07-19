//
//  FTEditTextLineViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 19/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"


@class FTEditTextLineViewController;

@protocol FTEditTextLineViewControllerDelegate <NSObject>

- (void)editTextLineController:(FTEditTextLineViewController *)controller didFinishedEditingWithString:(NSString *)string;

@end


@interface FTEditTextLineViewController : FTViewController {
	
	UITextField *textField;
	
	id <FTEditTextLineViewControllerDelegate> delegate;
	
}


@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, assign) id <FTEditTextLineViewControllerDelegate> delegate;


@end
