//
//  FTPageViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 25/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTViewController.h"

@interface FTPageViewController : FTViewController {
	
	NSInteger pageIndex;
	
}

@property (nonatomic) NSInteger pageIndex;


- (void)doInit;


@end
