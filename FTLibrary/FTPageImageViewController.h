//
//  FTPageImageViewController.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 25/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPageViewController.h"
#import <UIKit/UIKit.h>


@interface FTPageImageViewController : FTPageViewController {
	
	UIImageView *pageImage;
	
}


@property (nonatomic, retain) UIImageView *pageImage;


- (id)initWithImage:(UIImage *)image;

+ (id)instanceWithImage:(UIImage *)image;


@end
