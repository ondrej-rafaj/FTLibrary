//
//  FTHorizontalTableHeaderView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHorizontalTableView.h"


@interface FTHorizontalTableHeaderView : UIView {
	
	FTHorizontalTableViewInitialRotation startPosition;
    
	FTHorizontalTableView *tableView;
	
	NSInteger *section;
	
}

@property (nonatomic, readonly) FTHorizontalTableViewInitialRotation startPosition;

@property (nonatomic, assign) FTHorizontalTableView *tableView;

@property (nonatomic) NSInteger *section;


- (id)initWithFrame:(CGRect)frame andStartPosition:(FTHorizontalTableViewInitialRotation)position;


@end
