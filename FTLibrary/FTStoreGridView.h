//
//  FTStoreGridView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "AQGridView.h"
#import "FTView.h"
#import "FTStoreGridViewCell.h"
#import "FTStoreDataObject.h"


@class FTStoreGridView;

@protocol FTStoreGridViewDelegate <NSObject>

- (void)storeGridView:(FTStoreGridView *)storeView didClickCellWithObject:(FTStoreDataObject *)dataObject atIndex:(NSInteger)index;

- (void)storeGridView:(FTStoreGridView *)storeView didClickActionButtonWithObject:(FTStoreDataObject *)dataObject atIndex:(NSInteger)index;

@end


@protocol FTStoreGridViewDataSource <NSObject>

- (NSInteger)numberOfItemsInStoreGridView:(FTStoreGridView *)storeView;

- (FTStoreDataObject *)storeGridView:(FTStoreGridView *)storeView dataObjectForItemAtIndex:(NSInteger)index;

- (UIImage *)defaultCellImageForStoreGridView:(FTStoreGridView *)storeView;

@end


@interface FTStoreGridView : FTView <AQGridViewDelegate, AQGridViewDataSource, FTStoreGridViewCellDelegate> {
	
	AQGridView *grid;
	
	id <FTStoreGridViewDelegate> delegate;
	id <FTStoreGridViewDataSource> dataSource;
	
}

@property (nonatomic, retain) AQGridView *grid;
@property (nonatomic, assign) id <FTStoreGridViewDelegate> delegate;
@property (nonatomic, assign) id <FTStoreGridViewDataSource> dataSource;

- (void)reloadData;

- (void)setHeaderImageUrl:(NSString *)headerUrl andFooterImageUrl:(NSString *)footerUrl;
- (void)setHeaderImage:(UIImage *)headerImage andFooterImage:(UIImage *)footerImage;


@end
