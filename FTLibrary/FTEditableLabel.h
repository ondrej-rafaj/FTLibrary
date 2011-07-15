//
//  FTEditableLabel.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTEditableElementView.h"


@interface FTEditableLabel : FTEditableElementView <UITextFieldDelegate> {
    
	UILabel *label;
	UITextField *input;
	
	BOOL animateEditToggle;
	
}

@property (nonatomic) BOOL animateEditToggle;


- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)color;
- (void)setTextAlignment:(UITextAlignment)alignment;
- (void)setFont:(UIFont *)font;
- (void)setBackgroundColorForAllElements:(UIColor *)color;


@end
