//
//  FTHorizontalTableView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHorizontalTableViewDelegate.h"
#import "FTHorizontalTableViewDataSource.h"


typedef enum {
	
	FTHorizontalTableViewInitialRotationNone,
	FTHorizontalTableViewInitialRotationLeft,
	FTHorizontalTableViewInitialRotationRight
	
} FTHorizontalTableViewInitialRotation;


@class FTHorizontalTableViewCell;


@interface FTHorizontalTableView : UITableView <UITableViewDelegate, UITableViewDataSource> {
    
	FTHorizontalTableViewInitialRotation startPosition;
	
	id <FTHorizontalTableViewDelegate> _horizontalTableDelegate;
	id <FTHorizontalTableViewDataSource> _horizontalTableDataSource;
	
}

@property (nonatomic) FTHorizontalTableViewInitialRotation startPosition;

@property (nonatomic) BOOL scrollsToStart;

@property (nonatomic, assign) id <FTHorizontalTableViewDelegate> horizontalDelegate;
@property (nonatomic, assign) id <FTHorizontalTableViewDataSource> dataSource;


- (CGFloat)widthForCell:(FTHorizontalTableViewCell *)cell;
- (CGFloat)heightForCell:(FTHorizontalTableViewCell *)cell;
- (CGFloat)heightForHeader;
- (CGFloat)heightForFooter;


@end
