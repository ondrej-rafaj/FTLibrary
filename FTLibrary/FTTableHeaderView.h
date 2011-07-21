//
//  FTTableHeaderView.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 20/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTTableHeaderView : UIView {
    
	UILabel *titleLabel;
	
	UIImageView *backgroundImageView;
	
}

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UIImageView *backgroundImageView;


@end
