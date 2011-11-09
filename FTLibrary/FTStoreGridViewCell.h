//
//  FTStoreGridViewCell.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "AQGridViewCell.h"
#import "FTGridViewCell.h"
#import "FTStoreDataObject.h"


@class FTStoreGridViewCell;

@protocol FTStoreGridViewCellDelegate <NSObject>

- (void)didClickActionButtonWithIndex:(NSInteger)index andObject:(FTStoreDataObject *)dataObject;
- (void)didClickCoverImageWithIndex:(NSInteger)index andObject:(FTStoreDataObject *)dataObject;

@end

@interface FTStoreGridViewCell : FTGridViewCell {
	
	UIView *storeView;
	
	UILabel *title;
	UILabel *description;
	UILabel *price;
	
	UIButton *buyButton;
	
	NSInteger cellIndex;
	FTStoreDataObject *dataObject;
	
	id <FTStoreGridViewCellDelegate> delegate;
	
}

@property (nonatomic, retain) UIView *storeView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIButton *buyButton;
@property (nonatomic) NSInteger cellIndex;
@property (nonatomic, retain) FTStoreDataObject *dataObject;
@property (nonatomic, assign) id <FTStoreGridViewCellDelegate> delegate;


- (void)setTitleText:(NSString *)text;
- (void)setPriceText:(NSString *)text;
- (void)setDescriptionText:(NSString *)text;


@end
