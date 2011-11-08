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


@class FTStoreGridView;

@protocol FTStoreGridViewDelegate <NSObject>

- (void)storeGridView:(FTStoreGridView *)storeView didClickCell:(FTStoreGridViewCell *)cell atIndex:(NSInteger)index;

@end


@interface FTStoreGridView : FTView <AQGridViewDelegate, AQGridViewDataSource> {
	
	AQGridView *grid;
	
	id <FTStoreGridViewDelegate> delegate;
	
}

@property (nonatomic, retain) AQGridView *grid;
@property (nonatomic, assign) id <FTStoreGridViewDelegate> delegate;

- (void)reloadData;


@end
