//
//  FTHorizontalTableViewCell.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHorizontalTableView.h"


@interface FTHorizontalTableViewCell : UITableViewCell {
	
	FTHorizontalTableViewInitialRotation startPosition;
	
	FTHorizontalTableView *tableView;
	
	NSIndexPath *indexPath;
	
}

@property (nonatomic, readonly) FTHorizontalTableViewInitialRotation startPosition;

@property (nonatomic, assign) FTHorizontalTableView *tableView;

@property (nonatomic, retain) NSIndexPath *indexPath;


@end
