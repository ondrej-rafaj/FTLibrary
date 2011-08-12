//
//  FTView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 12/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"
#import "UIView+Effects.h"


@interface FTView : UIView {
	
	UIImageView *backgroundImage;
	
}

@property (nonatomic, retain) UIImageView *backgroundImage;


- (void)enableBackgroundImage:(UIImage *)image;


@end
