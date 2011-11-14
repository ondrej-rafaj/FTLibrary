//
//  FTUnlimitedGridView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 13/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "FTUnlimitedGridViewCell.h"


//struct FTUnlimitedGridViewCellCoordinate {
//	CGFloat x;
//	CGFloat y;
//};
//typedef struct CGPoint FTUnlimitedGridViewCellCoordinate;


@class FTUnlimitedGridView;

@protocol FTUnlimitedGridViewDelegate <NSObject>

@optional

@end


@protocol FTUnlimitedGridViewDataSource <NSObject>

- (CGSize)cellSizeForUnlimitedGridView:(FTUnlimitedGridView *)gridView;

- (FTUnlimitedGridViewCell *)unlimitedGridView:(FTUnlimitedGridView *)gridView cellForCoordinate:(FTUnlimitedGridViewCellCoordinate)coordinate;

@end


@interface FTUnlimitedGridView : FTView <UIScrollViewDelegate> {
	
	UIScrollView *mainScrollView;
	UIView *contentView;
	
	NSMutableArray *_visibleCells;
	NSMutableDictionary *_reusableGridCells;
	
	CGPoint _virtualContentOffset;
	
	CGSize _cellSize;
	
	id <FTUnlimitedGridViewDelegate> delegate;
	id <FTUnlimitedGridViewDataSource> dataSource;
	
	int leftColumn;
	int rightColumn;
	int topRow;
	int bottomRow;
	
}

@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) id <FTUnlimitedGridViewDelegate> delegate;
@property (nonatomic, assign) id <FTUnlimitedGridViewDataSource> dataSource;

- (FTUnlimitedGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (CGRect)visibleBounds;
- (void)reloadData;


@end
