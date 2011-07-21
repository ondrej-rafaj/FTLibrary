//
//  FTTableViewCell.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTImageView.h"


@interface FTTableViewCell : UITableViewCell {
    
	IBOutlet UILabel *cellTitleLabel;
	IBOutlet UILabel *cellDetailLabel;
	IBOutlet UILabel *cellStatsLabel;
	
	FTImageView *cellImageView;
	
	id dataObject;
	
	UIImageView *background;
	
}

@property (nonatomic, retain) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *cellDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *cellStatsLabel;

@property (nonatomic, retain) IBOutlet FTImageView *cellImageView;

@property (nonatomic, retain) id dataObject;

@property (nonatomic, retain) UIImageView *background;


- (void)doInit;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDynamicDetailText:(NSString *)text;

- (void)enableBackgroundWithImage:(UIImage *)imageNamed;


@end