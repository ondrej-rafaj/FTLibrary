//
//  FTPage.h
//  FTLibrary
//
//  Created by Fuerte on 04/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPageDelegate.h"
#import "FTPageLocation.h"


@interface FTPage : UIView {
	
	FTPageLocation *location;
	
	id <FTPageDelegate> pageDelegate;
	
	int pageIndex;
	
}


@property (nonatomic, assign) id <FTPageDelegate> pageDelegate;

@property (nonatomic, retain) FTPageLocation *location;

@property (nonatomic) int pageIndex;


@end
