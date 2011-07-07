//
//  FTViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 28/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FTViewController : UIViewController {
    
	UITableView *table;
	
	NSArray *data;
	
	BOOL isLandscape;
    
    UIImageView *backgroundView;
	
}

@property (nonatomic, retain) UITableView *table;

@property (nonatomic, retain) NSArray *data;

@property (nonatomic, retain) UIImageView *backgroundView;


- (CGRect)fullscreenRect;

- (void)setBackgroundWithImageName:(NSString *)imageName;


@end
