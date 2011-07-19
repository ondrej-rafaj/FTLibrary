//
//  FTViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTTableViewCell.h"


@interface FTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
	UITableView *table;
	
	NSArray *data;
	
	UIImageView *backgroundView;
	
	BOOL isLandscape;
	
}

@property (nonatomic, retain) UITableView *table;

@property (nonatomic, retain) NSArray *data;

@property (nonatomic, retain) UIImageView *backgroundView;

@property (nonatomic) BOOL isLandscape;


- (CGRect)fullscreenRect;

- (void)setBackgroundWithImageName:(NSString *)imageName;

- (void)doLayoutSubviews;

- (void)createTableViewWithStyle:(UITableViewStyle)style andAddToTheMainView:(BOOL)addToView;
- (void)createTableViewWithStyle:(UITableViewStyle)style;
- (void)createTableView;

- (void)configureCell:(FTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end
