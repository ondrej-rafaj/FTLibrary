//
//  FTStoreGridViewCell.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "AQGridViewCell.h"
#import "FTGridViewCell.h"

@interface FTStoreGridViewCell : FTGridViewCell {
	
	UIView *storeView;
	
	UILabel *title;
	UILabel *description;
	UILabel *price;
	
	UIButton *buyButton;
	
}

@property (nonatomic, retain) UIView *storeView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIButton *buyButton;

@end
