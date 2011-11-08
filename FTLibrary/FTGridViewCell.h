//
//  FTGridViewCell.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "AQGridViewCell.h"
#import "FTImageView.h"


@interface FTGridViewCell : AQGridViewCell {
	
	FTImageView *imageView;
	
}

@property (nonatomic, retain) FTImageView *imageView;


- (void)initializeView;


@end
