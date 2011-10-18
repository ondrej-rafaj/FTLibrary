//
//  FTBarButtonItem.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 18/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	
	FTBarButtonItemStyleInLineButtonBlack,
	FTBarButtonItemStyleInLineButtonGray,
	FTBarButtonItemStyleInLineButtonWhite
	
} FTBarButtonItemStyle;


@class FTBarButtonItem;

@interface FTBarButtonItemButton : UIButton
@property (nonatomic, assign) FTBarButtonItem *barButtonItem;
@end


@interface FTBarButtonItem : UIBarButtonItem {
	
	FTBarButtonItemButton *customElement;
	
	FTBarButtonItemStyle _style;
	
}

@property (nonatomic, retain) UIView *customElement;

- (id)initWithTitle:(NSString *)title withFTStyle:(FTBarButtonItemStyle)style target:(id)target action:(SEL)action;

- (void)setCustomStyle:(FTBarButtonItemStyle)style;

- (FTBarButtonItemStyle)customStyle;

- (void)setAlpha:(CGFloat)alpha;
- (CGFloat)alpha;


@end
